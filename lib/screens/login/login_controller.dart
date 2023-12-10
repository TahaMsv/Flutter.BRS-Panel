import 'dart:convert';

import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/platform/encryptor.dart';
import 'package:brs_panel/core/platform/network_manager.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/core/util/confirm_operation.dart';
import 'package:brs_panel/screens/login/usecases/server_select_usecase.dart';
import 'package:brs_panel/widgets/ServerSelectDialog.dart';
import 'package:brs_panel/widgets/stimul_preview_dialog.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/device_info_service_abs.dart';
import '../../core/classes/new_version_class.dart';
import '../../core/classes/server_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/share_prefrences_keys.dart';
import '../../core/navigation/route_names.dart';
import '../../core/platform/device_info.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../initialize.dart';
import 'login_state.dart';
import 'usecases/login_usecase.dart';

class LoginController extends MainController {
  late LoginState loginState = ref.read(loginProvider);

  @override
  onCreate() {
    // loadPreferences();
  }

  Future<LoginUser?> login() async {
    LoginUser? user;
    DeviceInfoService deviceInfoService = getIt<DeviceInfoService>();
    DeviceInfo deviceInfo = deviceInfoService.getInfo();

    String username = loginState.usernameC.text;
    String password = loginState.passwordC.text;
    password = Encryptor.encryptPassword(password);

    String al = loginState.alC.text;

    LoginUseCase loginUsecase = LoginUseCase();
    LoginRequest loginRequest = LoginRequest(
      username: username,
      password: password,
      newPassword: '',
      deviceInfo: deviceInfo,
      al: al,
      cachedUser: null,
    );
    print("Aa");
    final fOrR = await loginUsecase(request: loginRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => login()), (r) {
      user = r.user ?? LoginUser.empty();
      user = user!.copyWith(username: username, password: password);
      prefs.setString(SpKeys.username, username);
      prefs.setString(SpKeys.password, loginState.passwordC.text);
      prefs.setString(SpKeys.airline, al);
      nav.goNamed(RouteNames.flights);
      BasicClass.initialize(user!, deviceInfo.screenType);
      final userP = ref.read(userProvider.notifier);
      userP.state = user;
    });
    return user;
  }

  void downloadNewVersion(NewVersion newVersion) {}

  loadPreferences() {
    print("loadPreferences");
    String user = prefs.getString(SpKeys.username) ?? "";
    String pass = prefs.getString(SpKeys.password) ?? "";
    String al = prefs.getString(SpKeys.airline) ?? "";
    String? server = prefs.getString(SpKeys.server);
    String? serverJson = prefs.getString(SpKeys.serverJson);
    loginState.usernameC.text = user;
    loginState.passwordC.text = pass;
    loginState.alC.text = al;
    if (serverJson != null) {
      Server s = Server.fromJson(jsonDecode(serverJson));
      ref.read(selectedServer.notifier).update((state) => s);
      initNetworkManager(s.address);
    } else {
      initNetworkManager(server);
    }
  }

  void logout([bool force = false]) async {
    if (force) {
      final userP = ref.read(userProvider.notifier);
      userP.state = null;
    } else {
      bool conf = await ConfirmOperation.getConfirm(
          Operation(message: "Are you sure?", title: "Logout?", actions: ["Confirm", 'Cancel']));
      if (conf) {
        String? serverJson = prefs.getString(SpKeys.serverJson);
        if (serverJson != null) {
          Server s = Server.fromJson(jsonDecode(serverJson));
          ref.read(selectedServer.notifier).update((state) => s);
          print("saved server ${s.name}: ${s.address}");
          initNetworkManager(s.address);
        }

        final userP = ref.read(userProvider.notifier);
        userP.state = null;
      }
    }
  }

  Future<List<Server>> getServers() async {
    List<Server> servers = [];
    ServerSelectUseCase getServersUsecase = ServerSelectUseCase();
    ServerSelectRequest serverSelectRequest = ServerSelectRequest();
    final fOrR = await getServersUsecase(request: serverSelectRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => getServers()), (r) {
      servers = r.servers;
      // print("Found ${r.servers.length} Servers");
      print(r.servers.map((e) => e.address).toList().join("\n"));
      print("CUrrent network: ${NetworkManager().currentBaseUrl}");
      final s = ref.read(selectedServer);
      nav
          .dialog(ServerSelectDialog(
        servers: servers,
        currentServer: servers.firstWhereOrNull(
            (e) => e.address.toLowerCase() == (s?.address.toLowerCase() ?? NetworkManager().currentBaseUrl)),
      ))
          .then((value) {
        if (value is Server) {
          if (value == null) return;
          print("Selected Server is ${value.address}");
          ref.read(selectedServer.notifier).update((state) => value);
          prefs.setString(SpKeys.serverJson, jsonEncode(value.toJson()));
          // NetworkManager().currentBaseUrl;
          initNetworkManager(value.address);
        }
      });
    });

    return servers;
  }

  void showStimulPreview() {
    // nav.dialog(StimulPreviewDialog(url: "http://www.google.com"));
  }

  void goToUserProfile() {
    nav.pushNamed(RouteNames.userSetting);
  }
}

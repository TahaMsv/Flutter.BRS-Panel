import 'package:brs_panel/core/platform/encryptor.dart';
import 'package:brs_panel/core/util/basic_class.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/device_info_service_abs.dart';
import '../../core/classes/new_version_class.dart';
import '../../core/classes/user_class.dart';
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
  onCreate(){
    loadPreferences();
  }

  Future<User?> login() async {
    User? user;
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

    final fOrR = await loginUsecase(request: loginRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => login()), (r) {
      user = r.user??User.empty();
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
    loginState.usernameC.text = user;
    loginState.passwordC.text = pass;
    loginState.alC.text = al;
    initNetworkManager(server);
  }
}

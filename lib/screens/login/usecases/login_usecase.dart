import 'package:brs_panel/core/util/app_config.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/device_info_service_abs.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../login_repository.dart';

class LoginUseCase extends UseCase<LoginResponse, LoginRequest> {
  LoginUseCase();

  @override
  Future<Either<Failure, LoginResponse>> call({required LoginRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    LoginRepository repository = LoginRepository();
    return repository.login(request);
  }
}

class LoginRequest extends Request {
  final String username;
  final String password;
  final String al;
  final String newPassword;
  final DeviceInfo deviceInfo;
  final LoginUser? cachedUser;

  LoginRequest({
    required this.username,
    required this.password,
    required this.newPassword,
    required this.deviceInfo,
    required this.al,
    required this.cachedUser,
  });

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "Login",
          "Token": token,
          "Request": {
            "Username": username,
            "Password": password,
            "NewPassword": newPassword,
            "Domain": "Flutter",
            "MotherPassword": false,
            "Company": deviceInfo.company,
            "Model": deviceInfo.deviceModel,
            "IsWifi": false,
            "AppName": "BRSPanel",
            "OSVersion": deviceInfo.osVersion,
            "VersionNum": deviceInfo.versionNumber,
            "Device": deviceInfo.deviceModel,
            "DeviceID": deviceInfo.deviceKey,
            "IsApplication": true,
            "FlavorName": AppConfig.instance!.flavor!.name,
            "Airline": al,
            "QrLogin":false,
          }
        }
      };

  Failure? validate() {
    return null;
  }
}

class LoginResponse extends Response {
  final LoginUser? user;

  LoginResponse({required int status, required String message, required this.user})
      : super(
          status: status,
          message: message,
          body: {
            "User": user?.toJson(),
          },
        );

  factory LoginResponse.fromResponse(Response res) {
    // print(res.body);
    return LoginResponse(
        status: res.status,
        message: res.message,
        user:res.body==null?null: LoginUser.fromJson(res.body),
      );
  }
}

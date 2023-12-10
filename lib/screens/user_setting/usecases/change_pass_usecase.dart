import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/platform/encryptor.dart';
import '../../../core/util/basic_class.dart';
import '../user_setting_repository.dart';

class ChangePassUseCase extends UseCase<ChangePassResponse, ChangePassRequest> {
  ChangePassUseCase();

  @override
  Future<Either<Failure, ChangePassResponse>> call({required ChangePassRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    UserSettingRepository repository = UserSettingRepository();
    return repository.changePass(request);
  }
}

class ChangePassRequest extends Request {
  ChangePassRequest({required this.oldPassV, required this.newPassV, required this.newPass2V});

  String oldPassV;
  String newPassV;
  String newPass2V;

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "ChangePassword",
          "Request": {"OldPass": Encryptor.encryptPassword(oldPassV), "NewPass": Encryptor.encryptPassword(newPassV)}
        }
      };

  Failure? validate() {
    String oldPass = Encryptor.encryptPassword(oldPassV);
    String newPass = Encryptor.encryptPassword(newPassV);
    String newPass2 = Encryptor.encryptPassword(newPass2V);
    String? msg;
    if (oldPass.isEmpty || newPass.isEmpty || newPass2.isEmpty) {
      msg = "Please fill all fields!";
    } else if (oldPass != BasicClass.userInfo.password) {
      msg = "Wrong Password!\nPlease enter you previous password again";
    } else if (newPassV.length < 4) {
      msg = "Invalid Password!\nPlease enter at least 4 characters";
    } else if (newPass != newPass2) {
      msg = "Failed to confirm the new password!";
    }
    return msg == null ? null : ValidationFailure(code: -1, msg: msg, traceMsg: "ChangePassUseCase>Validation");
  }
}

class ChangePassResponse extends Response {
  ChangePassResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory ChangePassResponse.fromResponse(Response res) {
    return ChangePassResponse(status: res.status, message: res.message);
  }
}

import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../users_repository.dart';

class AddUpdateUserUseCase extends UseCase<AddUpdateUserResponse, AddUpdateUserRequest> {
  AddUpdateUserUseCase();

  @override
  Future<Either<Failure, AddUpdateUserResponse>> call({required AddUpdateUserRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    UsersRepository repository = UsersRepository();
    return repository.addUpdateUser(request);
  }
}

class AddUpdateUserRequest extends Request {
  final User user0;

  AddUpdateUserRequest({required this.user0});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "AddUpdateUser",
          "Request": user0.toJson(),
        }
      };

  Failure? validate() {
    String? msg;
    if (user0.username.isEmpty) {
      msg = "Username must not be empty!";
    } else if (user0.password?.isEmpty ?? true && user0.id==0) {
      msg = "Password must not be empty!";
    } else if (user0.name.isEmpty) {
      msg = "User's name must not be empty!";
    } else if (user0.al.isEmpty) {
      msg = "Airline must not be empty!";
    } else if (user0.al.isEmpty) {
      msg = "Airline must not be empty!";
    } else if (user0.airport.isEmpty) {
      msg = "Airport must not be empty!";
    }
    return msg == null ? null : ValidationFailure(code: -1, msg: msg, traceMsg: "AddUpdateUserUseCase>Validation");
  }
}

class AddUpdateUserResponse extends Response {
  final List<User>? users;

  AddUpdateUserResponse({required int status, required String message, required this.users})
      : super(status: status, message: message, body: users?.map((e) => e.toJson()).toList());

  factory AddUpdateUserResponse.fromResponse(Response res) {
    return AddUpdateUserResponse(
      status: res.status,
      message: res.message,
      users: res.body == null ? null : List<User>.from(res.body["UserList"].map((x) => User.fromJson(x))),
    );
  }
}

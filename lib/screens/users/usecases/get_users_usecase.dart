import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../users_repository.dart';

class GetUsersUseCase extends UseCase<GetUsersResponse, GetUsersRequest> {
  GetUsersUseCase();

  @override
  Future<Either<Failure, GetUsersResponse>> call({required GetUsersRequest request}) {
    UsersRepository repository = UsersRepository();
    return repository.getUsers(request);
  }
}

class GetUsersRequest extends Request {
  GetUsersRequest();

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "UserList",
        }
      };
}

class GetUsersResponse extends Response {
  final List<User>? users;

  GetUsersResponse({required int status, required String message, required this.users})
      : super(status: status, message: message, body: users?.map((e) => e.toJson()).toList());

  factory GetUsersResponse.fromResponse(Response res) {
    return GetUsersResponse(
      status: res.status,
      message: res.message,
      users: res.body == null ? null : List<User>.from(res.body["UserList"].map((x) => User.fromJson(x))),
    );
  }
}

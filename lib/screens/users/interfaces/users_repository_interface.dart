import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/add_update_user_usecase.dart';
import '../usecases/get_users_usecase.dart';

abstract class UsersRepositoryInterface {
  Future<Either<Failure, GetUsersResponse>> getUsers(GetUsersRequest request);
  Future<Either<Failure, AddUpdateUserResponse>> addUpdateUser(AddUpdateUserRequest request);
}

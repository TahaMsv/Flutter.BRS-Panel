import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/users_repository_interface.dart';
import 'data_sources/users_local_ds.dart';
import 'data_sources/users_remote_ds.dart';
import 'usecases/add_update_user_usecase.dart';
import 'usecases/get_users_usecase.dart';

class UsersRepository implements UsersRepositoryInterface {
  final UsersRemoteDataSource usersRemoteDataSource = UsersRemoteDataSource();
  final UsersLocalDataSource usersLocalDataSource = UsersLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  UsersRepository();

  @override
  Future<Either<Failure, GetUsersResponse>> getUsers(GetUsersRequest request) async {
    try {
      GetUsersResponse getUsersResponse;
      if (await networkInfo.isConnected) {
        getUsersResponse = await usersRemoteDataSource.getUsers(request: request);
      } else {
        getUsersResponse = await usersLocalDataSource.getUsers(request: request);
      }
      return Right(getUsersResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, AddUpdateUserResponse>> addUpdateUser(AddUpdateUserRequest request) async {
    try {
      AddUpdateUserResponse addUpdateUserResponse;
      if (await networkInfo.isConnected) {
        addUpdateUserResponse = await usersRemoteDataSource.addUpdateUser(request: request);
      } else {
        addUpdateUserResponse = await usersLocalDataSource.addUpdateUser(request: request);
      }
      return Right(addUpdateUserResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}

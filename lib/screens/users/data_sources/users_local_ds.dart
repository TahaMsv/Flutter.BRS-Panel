import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/users_data_source_interface.dart';
import '../usecases/add_update_user_usecase.dart';
import '../usecases/get_users_usecase.dart';

const String userJsonLocalKey = "UserJson";

class UsersLocalDataSource implements UsersDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  UsersLocalDataSource();

  @override
  Future<GetUsersResponse> getUsers({required GetUsersRequest request}) {
    throw UnimplementedError();
  }

  @override
  Future<AddUpdateUserResponse> addUpdateUser({required AddUpdateUserRequest request}) {
    throw UnimplementedError();
  }
}

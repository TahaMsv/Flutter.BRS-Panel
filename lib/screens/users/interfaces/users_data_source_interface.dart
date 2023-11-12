import '../usecases/add_update_user_usecase.dart';
import '../usecases/get_users_usecase.dart';

abstract class UsersDataSourceInterface {
  Future<GetUsersResponse> getUsers({required GetUsersRequest request});
  Future<AddUpdateUserResponse> addUpdateUser({required AddUpdateUserRequest request});
}

import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/users_data_source_interface.dart';
import '../usecases/add_update_user_usecase.dart';
import '../usecases/get_users_usecase.dart';
import 'users_local_ds.dart';

class UsersRemoteDataSource implements UsersDataSourceInterface {
  final UsersLocalDataSource localDataSource = UsersLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  UsersRemoteDataSource();

  @override
  Future<GetUsersResponse> getUsers({required GetUsersRequest request}) async {
    Response res = await networkManager.post(request);
    return GetUsersResponse.fromResponse(res);
  }

  @override
  Future<AddUpdateUserResponse> addUpdateUser({required AddUpdateUserRequest request}) async {
    Response res = await networkManager.post(request);
    return AddUpdateUserResponse.fromResponse(res);
  }
}

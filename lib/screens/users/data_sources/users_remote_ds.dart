import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/users_data_source_interface.dart';
import 'users_local_ds.dart';

class UsersRemoteDataSource implements UsersDataSourceInterface {
  final UsersLocalDataSource localDataSource = UsersLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  UsersRemoteDataSource();
}

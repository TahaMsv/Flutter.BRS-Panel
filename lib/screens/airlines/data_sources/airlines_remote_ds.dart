import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airlines_data_source_interface.dart';
import 'airlines_local_ds.dart';

class AirlinesRemoteDataSource implements AirlinesDataSourceInterface {
  final AirlinesLocalDataSource localDataSource = AirlinesLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  AirlinesRemoteDataSource();
}

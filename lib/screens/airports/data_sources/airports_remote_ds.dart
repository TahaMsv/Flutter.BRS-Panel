import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airports_data_source_interface.dart';
import 'airports_local_ds.dart';

class AirportsRemoteDataSource implements AirportsDataSourceInterface {
  final AirportsLocalDataSource localDataSource = AirportsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  AirportsRemoteDataSource();
}

import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/aircrafts_data_source_interface.dart';
import 'aircrafts_local_ds.dart';

class AircraftsRemoteDataSource implements AircraftsDataSourceInterface {
  final AircraftsLocalDataSource localDataSource = AircraftsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  AircraftsRemoteDataSource();
}

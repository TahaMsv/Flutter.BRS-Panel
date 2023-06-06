import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airline_ulds_data_source_interface.dart';
import 'airline_ulds_local_ds.dart';

class AirlineUldsRemoteDataSource implements AirlineUldsDataSourceInterface {
  final AirlineUldsLocalDataSource localDataSource = AirlineUldsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  AirlineUldsRemoteDataSource();
}

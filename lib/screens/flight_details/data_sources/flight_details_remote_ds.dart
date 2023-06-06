import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/flight_details_data_source_interface.dart';
import 'flight_details_local_ds.dart';

class FlightDetailsRemoteDataSource implements FlightDetailsDataSourceInterface {
  final FlightDetailsLocalDataSource localDataSource = FlightDetailsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();
  FlightDetailsRemoteDataSource();
}

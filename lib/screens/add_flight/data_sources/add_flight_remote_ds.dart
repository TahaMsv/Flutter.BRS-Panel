import 'dart:io';


import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/add_flight_data_source_interface.dart';
import '../usecases/add_flight_usecase.dart';
import 'add_flight_local_ds.dart';

class AddFlightRemoteDataSource implements AddFlightDataSourceInterface {
  final AddFlightLocalDataSource localDataSource = AddFlightLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AddFlightRemoteDataSource();

  @override
  Future<AddFlightResponse> addFlight({required AddFlightRequest request}) async {
    Response res = await networkManager.post(request);
    try {
      return AddFlightResponse.fromResponse(res);
    } catch (e) {
      throw ParseException(message: e.toString(), trace: StackTrace.fromString(e.toString()));
    }
  }
}

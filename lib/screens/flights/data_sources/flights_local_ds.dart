import 'dart:developer';
import 'package:brs_panel/screens/flights/usecases/flight_add_remove_container_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_container_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/flights_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class FlightsLocalDataSource implements FlightsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  FlightsLocalDataSource();

  @override
  Future<FlightListResponse> flightList({required FlightListRequest request}) {
    // TODO: implement flightList
    throw UnimplementedError();
  }

  @override
  Future<FlightGetContainerListResponse> flightGetContainerList({required FlightGetContainerListRequest request}) {
    // TODO: implement flightGetContainerList
    throw UnimplementedError();
  }

  @override
  Future<FlightAddRemoveContainerResponse> flightAddRemoveContainer({required FlightAddRemoveContainerRequest request}) {
    // TODO: implement flightAddRemoveContainer
    throw UnimplementedError();
  }



}

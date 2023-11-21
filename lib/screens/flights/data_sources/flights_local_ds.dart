import 'dart:developer';
import 'package:brs_panel/screens/flights/usecases/flight_add_remove_container_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_container_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_containers_plan_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_plan_file.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_report_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_save_containers_plan_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_send_report_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/login_user_class.dart';
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

  @override
  Future<FlightGetContainersPlanResponse> flightGetContainersPlan({required FlightGetContainersPlanRequest request}) {
    // TODO: implement flightGetContainersPlan
    throw UnimplementedError();
  }

  @override
  Future<FlightGetPlanFileResponse> flightGetPlanFile({required FlightGetPlanFileRequest request}) {
    // TODO: implement flightGetPlanFile
    throw UnimplementedError();
  }

  @override
  Future<FlightSaveContainersPlanResponse> flightSaveContainersPlan({required FlightSaveContainersPlanRequest request}) {
    // TODO: implement flightSaveContainersPlan
    throw UnimplementedError();
  }

  @override
  Future<FlightGetReportResponse> flightGetReport({required FlightGetReportRequest request}) {
    // TODO: implement flightGetReport
    throw UnimplementedError();
  }

  @override
  Future<FlightSendReportResponse> flightSendReport({required FlightSendReportRequest request}) {
    // TODO: implement flightSendReport
    throw UnimplementedError();
  }



}

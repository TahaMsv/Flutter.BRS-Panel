import 'dart:developer';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_history_log_usecase.dart';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_summary_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/flight_summary_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class FlightSummaryLocalDataSource implements FlightSummaryDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  FlightSummaryLocalDataSource();

  @override
  Future<FlightGetSummaryResponse> flightGetSummary({required FlightGetSummaryRequest request}) {
    // TODO: implement flightGetSummary
    throw UnimplementedError();
  }

  @override
  Future<FlightGetHistoryLogResponse> flightGetHistoryLog({required FlightGetHistoryLogRequest request}) {
    // TODO: implement flightGetHistoryLog
    throw UnimplementedError();
  }



}

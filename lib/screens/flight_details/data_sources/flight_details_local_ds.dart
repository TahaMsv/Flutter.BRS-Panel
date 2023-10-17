import 'dart:developer';
import 'package:brs_panel/screens/flight_details/usecases/flight_get_details_usecase.dart';
import 'package:brs_panel/screens/flight_details/usecases/flight_get_tag_details_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/flight_details_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class FlightDetailsLocalDataSource implements FlightDetailsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  FlightDetailsLocalDataSource();

  @override
  Future<FlightGetDetailsResponse> flightGetDetails({required FlightGetDetailsRequest request}) {
    // TODO: implement flightGetDetails
    throw UnimplementedError();
  }

  @override
  Future<FlightGetTagMoreDetailsResponse> flightGetTagMoreDetails({required FlightGetTagMoreDetailsRequest request}) {
    // TODO: implement flightGetTagMoreDetails
    throw UnimplementedError();
  }



}

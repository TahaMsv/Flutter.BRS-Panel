import 'dart:developer';
import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/aircrafts_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AircraftsLocalDataSource implements AircraftsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  AircraftsLocalDataSource();



}

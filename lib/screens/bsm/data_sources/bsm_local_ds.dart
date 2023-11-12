import 'dart:developer';
import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/bsm_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class BsmLocalDataSource implements BsmDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  BsmLocalDataSource();

  @override
  Future<BsmListResponse> bsmList({required BsmListRequest request}) {
    // TODO: implement bsmList
    throw UnimplementedError();
  }

  @override
  Future<AddBSMResponse> addBsm({required AddBSMRequest request}) {
    // TODO: implement addBsm
    throw UnimplementedError();
  }



}

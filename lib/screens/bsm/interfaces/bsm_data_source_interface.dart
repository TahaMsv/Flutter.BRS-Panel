import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';

abstract class BsmDataSourceInterface {
  Future<BsmListResponse> bsmList({required BsmListRequest request});
  Future<AddBSMResponse> addBsm({required AddBSMRequest request});
}
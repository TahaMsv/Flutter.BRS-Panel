import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';

abstract class BsmRepositoryInterface {
  Future<Either<Failure, BsmListResponse>> bsmList(BsmListRequest request);
  Future<Either<Failure, AddBSMResponse>> addBsm(AddBSMRequest request);
}
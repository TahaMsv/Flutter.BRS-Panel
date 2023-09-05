import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/bsm_repository_interface.dart';
import 'data_sources/bsm_local_ds.dart';
import 'data_sources/bsm_remote_ds.dart';
import 'usecases/add_bsm_usecase.dart';
import 'usecases/bsm_list_usecase.dart';

class BsmRepository implements BsmRepositoryInterface {
  final BsmRemoteDataSource bsmRemoteDataSource = BsmRemoteDataSource();
  final BsmLocalDataSource bsmLocalDataSource = BsmLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  BsmRepository();

  @override
  Future<Either<Failure, BsmListResponse>> bsmList(BsmListRequest request) async {
    try {
      BsmListResponse bsmListResponse;
      if (await networkInfo.isConnected) {
        bsmListResponse = await bsmRemoteDataSource.bsmList(request: request);
      } else {
        bsmListResponse = await bsmLocalDataSource.bsmList(request: request);
      }
      return Right(bsmListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, AddBSMResponse>> addBsm(AddBSMRequest request) async {
    try {
      AddBSMResponse addBsmResponse;
      if (await networkInfo.isConnected) {
        addBsmResponse = await bsmRemoteDataSource.addBsm(request: request);
      } else {
        addBsmResponse = await bsmLocalDataSource.addBsm(request: request);
      }
      return Right(addBsmResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}

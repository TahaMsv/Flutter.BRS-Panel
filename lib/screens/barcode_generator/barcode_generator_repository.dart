import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'data_sources/barcode_generator_local_ds.dart';
import 'interfaces/barcode_generator_repository_interface.dart';


class BsmRepository implements BarcodeGeneratorRepositoryInterface {
  final BarcodeGeneratorDataSource bsmRemoteDataSource = BarcodeGeneratorDataSource();
  final BarcodeGeneratorDataSource bsmLocalDataSource = BarcodeGeneratorDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  BsmRepository();
}

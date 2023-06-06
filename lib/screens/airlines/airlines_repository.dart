import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airlines_repository_interface.dart';
import 'data_sources/airlines_local_ds.dart';
import 'data_sources/airlines_remote_ds.dart';

class AirlinesRepository implements AirlinesRepositoryInterface {
  final AirlinesRemoteDataSource airlinesRemoteDataSource = AirlinesRemoteDataSource();
  final AirlinesLocalDataSource airlinesLocalDataSource = AirlinesLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirlinesRepository();
}

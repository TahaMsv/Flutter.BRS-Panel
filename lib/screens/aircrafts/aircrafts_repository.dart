import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/aircrafts_repository_interface.dart';
import 'data_sources/aircrafts_local_ds.dart';
import 'data_sources/aircrafts_remote_ds.dart';

class AircraftsRepository implements AircraftsRepositoryInterface {
  final AircraftsRemoteDataSource aircraftsRemoteDataSource = AircraftsRemoteDataSource();
  final AircraftsLocalDataSource aircraftsLocalDataSource = AircraftsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AircraftsRepository();
}

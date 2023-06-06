import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airline_ulds_repository_interface.dart';
import 'data_sources/airline_ulds_local_ds.dart';
import 'data_sources/airline_ulds_remote_ds.dart';

class AirlineUldsRepository implements AirlineUldsRepositoryInterface {
  final AirlineUldsRemoteDataSource airline_uldsRemoteDataSource = AirlineUldsRemoteDataSource();
  final AirlineUldsLocalDataSource airline_uldsLocalDataSource = AirlineUldsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirlineUldsRepository();
}

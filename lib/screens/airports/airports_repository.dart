import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airports_repository_interface.dart';
import 'data_sources/airports_local_ds.dart';
import 'data_sources/airports_remote_ds.dart';

class AirportsRepository implements AirportsRepositoryInterface {
  final AirportsRemoteDataSource airportsRemoteDataSource = AirportsRemoteDataSource();
  final AirportsLocalDataSource airportsLocalDataSource = AirportsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirportsRepository();
}

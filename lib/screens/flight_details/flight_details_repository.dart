import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/flight_details_repository_interface.dart';
import 'data_sources/flight_details_local_ds.dart';
import 'data_sources/flight_details_remote_ds.dart';

class FlightDetailsRepository implements FlightDetailsRepositoryInterface {
  final FlightDetailsRemoteDataSource flight_detailsRemoteDataSource = FlightDetailsRemoteDataSource();
  final FlightDetailsLocalDataSource flight_detailsLocalDataSource = FlightDetailsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  FlightDetailsRepository();
}

import 'package:brs_panel/screens/airport_carts/usecase/airport_get_carts_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';

abstract class AirportCartsRepositoryInterface {
  Future<Either<Failure, AirportGetCartsResponse>> airportGetCarts(AirportGetCartsRequest request);
}
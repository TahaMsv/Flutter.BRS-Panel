import 'package:brs_panel/screens/airport_carts/usecase/airport_get_carts_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecase/airline_add_uld_usecase.dart';
import '../usecase/airline_delete_uld_usecase.dart';
import '../usecase/airline_update_uld_usecase.dart';

abstract class AirportCartsRepositoryInterface {
  Future<Either<Failure, AirportGetCartsResponse>> airportGetCarts(AirportGetCartsRequest request);
  Future<Either<Failure, AirportAddCartResponse>> airportAddCart(AirportAddCartRequest request);
  Future<Either<Failure, AirportUpdateCartResponse>> airportUpdateCart(AirportUpdateCartRequest request);
  Future<Either<Failure, AirportDeleteCartResponse>> airportDeleteCart(AirportDeleteCartRequest request);
}
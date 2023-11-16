import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecase/airport_get_sections_usecase.dart';
import '../usecase/airport_update_sections_usecase.dart';

abstract class AirportSectionsRepositoryInterface {
  Future<Either<Failure, AirportGetSectionsResponse>> airportGetSections(AirportGetSectionsRequest request);
  Future<Either<Failure, AirportUpdateSectionsResponse>> airportUpdateSections(AirportUpdateSectionsRequest request);
}

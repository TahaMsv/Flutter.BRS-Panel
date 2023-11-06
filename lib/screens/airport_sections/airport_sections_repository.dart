import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airport_sections_repository_interface.dart';
import 'data_sources/airport_sections_local_ds.dart';
import 'data_sources/airport_sections_remote_ds.dart';
import 'usecase/airport_get_sections_usecase.dart';

class AirportSectionsRepository implements AirportSectionsRepositoryInterface {
  final AirportSectionsRemoteDataSource airportSectionsRemoteDataSource = AirportSectionsRemoteDataSource();
  final AirportSectionsLocalDataSource airportSectionsLocalDataSource = AirportSectionsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirportSectionsRepository();

  @override
  Future<Either<Failure, AirportGetSectionsResponse>> airportGetSections(AirportGetSectionsRequest request) async {
    try {
      AirportGetSectionsResponse sectionsResponse;
      if (await networkInfo.isConnected) {
        sectionsResponse = await airportSectionsRemoteDataSource.airportGetSections(request: request);
      } else {
        sectionsResponse = await airportSectionsLocalDataSource.airportGetSections(request: request);
      }
      return Right(sectionsResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}

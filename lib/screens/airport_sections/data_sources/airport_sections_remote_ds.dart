import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airport_sections_data_source_interface.dart';
import '../usecase/airport_get_sections_usecase.dart';
import '../usecase/airport_update_sections_usecase.dart';
import 'airport_sections_local_ds.dart';

class AirportSectionsRemoteDataSource implements AirportSectionsDataSourceInterface {
  final AirportSectionsLocalDataSource localDataSource = AirportSectionsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirportSectionsRemoteDataSource();

  @override
  Future<AirportGetSectionsResponse> airportGetSections({required AirportGetSectionsRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportGetSectionsResponse.fromResponse(res);
  }

  @override
  Future<AirportUpdateSectionsResponse> airportUpdateSections({required AirportUpdateSectionsRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportUpdateSectionsResponse.fromResponse(res);
  }
}

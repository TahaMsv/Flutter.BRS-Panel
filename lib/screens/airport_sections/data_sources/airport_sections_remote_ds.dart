import 'dart:convert';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airport_sections_data_source_interface.dart';
import '../usecase/airport_get_sections_usecase.dart';
import 'airport_sections_local_ds.dart';

class AirportSectionsRemoteDataSource implements AirportSectionsDataSourceInterface {
  final AirportSectionsLocalDataSource localDataSource = AirportSectionsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirportSectionsRemoteDataSource();

  @override
  Future<AirportGetSectionsResponse> airportGetSections({required AirportGetSectionsRequest request}) async {
    Response res = await networkManager.post(request);
    print(jsonEncode(res.body));
    return AirportGetSectionsResponse.fromResponse(res);
  }
}

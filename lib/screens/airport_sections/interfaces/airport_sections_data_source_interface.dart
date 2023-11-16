import '../usecase/airport_get_sections_usecase.dart';
import '../usecase/airport_update_sections_usecase.dart';

abstract class AirportSectionsDataSourceInterface {
  Future<AirportGetSectionsResponse> airportGetSections({required AirportGetSectionsRequest request});
  Future<AirportUpdateSectionsResponse> airportUpdateSections({required AirportUpdateSectionsRequest request});
}

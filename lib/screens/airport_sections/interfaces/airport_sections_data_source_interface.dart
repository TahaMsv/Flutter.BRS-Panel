import '../usecase/airport_get_sections_usecase.dart';

abstract class AirportSectionsDataSourceInterface {
  Future<AirportGetSectionsResponse> airportGetSections({required AirportGetSectionsRequest request});
}

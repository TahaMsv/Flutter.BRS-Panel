import 'package:brs_panel/screens/airport_sections/usecase/airport_get_sections_usecase.dart';
import 'package:brs_panel/screens/airport_sections/usecase/airport_update_sections_usecase.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/airport_sections_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AirportSectionsLocalDataSource implements AirportSectionsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  AirportSectionsLocalDataSource();

  @override
  Future<AirportGetSectionsResponse> airportGetSections({required AirportGetSectionsRequest request}) {
    // TODO: implement airportGetSections
    throw UnimplementedError();
  }

  @override
  Future<AirportUpdateSectionsResponse> airportUpdateSections({required AirportUpdateSectionsRequest request}) {
    // TODO: implement airportUpdateSections
    throw UnimplementedError();
  }
}

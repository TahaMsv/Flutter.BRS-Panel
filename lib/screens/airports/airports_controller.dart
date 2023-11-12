import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:brs_panel/screens/airport_carts/airport_carts_state.dart';
import 'package:brs_panel/screens/airport_sections/airport_sections_state.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../initialize.dart';
import '../airport_carts/airport_carts_controller.dart';
import '../airport_sections/airport_sections_controller.dart';
import 'airports_state.dart';

class AirportsController extends MainController {
  late AirportsState airportsState = ref.read(airportsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<void> goCarts(Airport a) async {
    final selectedAirportP = ref.read(selectedAirportProvider.notifier);
    selectedAirportP.state = a;
    AirportCartsController airportCartsController = getIt<AirportCartsController>();
    final ulds = await airportCartsController.airportGetCarts();
    if (ulds != null) {
      nav.pushNamed(RouteNames.airportCarts);
    }
  }

  Future<void> goSections(Airport a) async {
    final selectedAirportP = ref.read(selectedAirportProvider.notifier);
    selectedAirportP.state = a;
    AirportSectionsController airportSectionsController = getIt<AirportSectionsController>();
    final sections = await airportSectionsController.airportGetSections();
    final airportSectionsP = ref.read(sectionsProvider.notifier);
    airportSectionsP.state = sections;
    airportSectionsController.initSelection();
    if (sections != null) nav.pushNamed(RouteNames.airportSections);
  }
}

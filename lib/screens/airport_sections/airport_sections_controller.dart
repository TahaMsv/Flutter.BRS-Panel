import 'package:brs_panel/core/classes/airport_section_class.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../airport_carts/airport_carts_state.dart';
import 'airport_sections_state.dart';
import 'usecase/airport_get_sections_usecase.dart';

class AirportSectionsController extends MainController {
  late AirportSectionsState airportSectionsState = ref.read(airportSectionsProvider);

  /// View Related -----------------------------------------------------------------------------------------------------

  onChangeSection() {}

  /// Requests ---------------------------------------------------------------------------------------------------------

  Future<AirportSections?> airportGetSections() async {
    Airport? sapP = ref.read(selectedAirportProvider);
    if (sapP == null) return null;
    AirportSections? sections;
    AirportGetSectionsUseCase airportGetSectionsUseCase = AirportGetSectionsUseCase();
    AirportGetSectionsRequest airportGetSectionsRequest = AirportGetSectionsRequest(airport: sapP);
    final fOrR = await airportGetSectionsUseCase(request: airportGetSectionsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportGetSections()), (r) {
      sections = r.airportSections;
    });
    return sections;
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  initSelection() {
    List<Section> sections = ref.read(sectionsProvider.notifier).state?.sections ?? [];
    if (sections.isEmpty) return;
    final selectedSectionP = ref.read(selectedSectionProvider.notifier);
    selectedSectionP.state = sections.first;
    final selectedCategoriesP = ref.read(selectedCategoriesProvider.notifier);
    selectedCategoriesP.state = [];
    setFirstSubCategories(sections.first.subCategories);
  }

  setFirstSubCategories(List<SubCategory> subs) {
    if (subs.isEmpty) return;
    final selectedCategoriesP = ref.read(selectedCategoriesProvider.notifier);
    List<SubCategory> prev = selectedCategoriesP.state;
    prev.add(subs.first);
    selectedCategoriesP.state = prev;
    setFirstSubCategories(subs.first.subCategories);
  }
}

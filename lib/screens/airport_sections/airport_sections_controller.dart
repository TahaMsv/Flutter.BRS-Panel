import 'package:brs_panel/initialize.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/airport_section_class.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../airport_carts/airport_carts_state.dart';
import 'airport_sections_state.dart';
import 'dialogs/add_section_dialog.dart';
import 'usecase/airport_get_sections_usecase.dart';

class AirportSectionsController extends MainController {
  late AirportSectionsState airportSectionsState = ref.read(airportSectionsProvider);

  /// View Related -----------------------------------------------------------------------------------------------------

  onTapSection(Section section) {
    final sectionsP = ref.read(sectionsProvider.notifier);
    List<Section> sc0 = sectionsP.state?.sections ?? [];
    final selectedSectionsP = ref.read(selectedSectionsProvider.notifier);
    List<Section> ssc0 = selectedSectionsP.state;
    if (sc0.any((e) => e == section)) {
      selectedSectionsP.state = [section];
      setFirstSections(section.sections);
    } else {
      for (int i = 0; i < ssc0.length; i++) {
        if (ssc0[i].sections.contains(section)) {
          List<Section> newSsc0 = ssc0.sublist(0, i + 1);
          newSsc0.add(section);
          selectedSectionsP.state = newSsc0;
          setFirstSections(section.sections);
        }
      }
    }
  }

  onDeleteSection(Section section) {
    final sectionsP = ref.read(sectionsProvider.notifier);
    List<Section> sc0 = sectionsP.state?.sections ?? [];
    final selectedSectionsP = ref.read(selectedSectionsProvider.notifier);
    List<Section> ssc0 = selectedSectionsP.state;
    if (sc0.any((e) => e == section)) {
      sc0.remove(section);
      if (ssc0.contains(section)) initSelection();
    } else {
      for (int i = 0; i < ssc0.length; i++) {
        if (ssc0[i].sections.contains(section)) {
          ssc0[i].sections.remove(section);
          if (ssc0.contains(section)) {
            ssc0 = ssc0.sublist(0, ssc0.indexOf(section));
            if (ssc0.isNotEmpty) setFirstSections(ssc0.last.sections);
          }
        }
      }
    }
    airportSectionsState.setState();
  }

  addSection({required List<Section> subs}) async {
    Section? newSection = await nav.dialog(const AddSectionDialog());
    if (newSection == null) return;
    final sectionsP = ref.read(sectionsProvider.notifier);
    List<Section> sc0 = sectionsP.state?.sections ?? [];
    final selectedSectionsP = ref.read(selectedSectionsProvider.notifier);
    List<Section> ssc0 = selectedSectionsP.state;
    if (subs.isEmpty) {
      if (sc0.isEmpty) {
        //first layer!
        sc0.add(newSection);
        sectionsP.state = AirportSections(airport: sectionsP.state?.airport ?? "", sections: sc0);
        selectedSectionsP.state = [newSection];
      } else {
        //last layer!
        ssc0[ssc0.length - 1].sections.add(newSection);
        setFirstSections(ssc0.last.sections);
      }
    } else if (sc0.contains(subs.first)) {
      //first layer!
      sc0.add(newSection);
      sectionsP.state = AirportSections(airport: sectionsP.state?.airport ?? "", sections: sc0);
      selectedSectionsP.state = [newSection];
    } else {
      //second layer!
      for (int i = 0; i < ssc0.length; i++) {
        List<Section> temp = ssc0[i].sections;
        if (temp.contains(subs.first)) {
          ssc0[i].sections.add(newSection);
        }
      }
    }
    airportSectionsState.setState();
  }

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

  updateSectionsRequest() async {
    // initSelection();
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  initSelection() {
    final selectedSectionsP = ref.read(selectedSectionsProvider.notifier);
    List<Section> sections = ref.read(sectionsProvider.notifier).state?.sections ?? [];
    if (sections.isEmpty) {
      selectedSectionsP.state = [];
      return;
    }
    selectedSectionsP.state = [sections.first];
    setFirstSections(sections.first.sections);
  }

  setFirstSections(List<Section> subs) {
    if (subs.isEmpty) return;
    final selectedSectionsP = ref.read(selectedSectionsProvider.notifier);
    List<Section> prev = selectedSectionsP.state;
    prev.add(subs.first);
    selectedSectionsP.state = prev;
    setFirstSections(subs.first.sections);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_section_class.dart';

final airportSectionsProvider = ChangeNotifierProvider<AirportSectionsState>((_) => AirportSectionsState());

class AirportSectionsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;
}

// final selectedAirportProvider = StateProvider<Airport?>((ref) => null);
final sectionsProvider = StateProvider<AirportSections?>((ref) => null);
final selectedSectionsProvider = StateProvider<List<Section>>((ref) => []);

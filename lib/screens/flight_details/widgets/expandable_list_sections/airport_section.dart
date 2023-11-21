import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import '../../../../core/classes/flight_details_class.dart';
import '../../../../core/classes/login_user_class.dart';
import '../../../../core/classes/tag_container_class.dart';
import '../../flight_details_state.dart';

class AirportSectionTagSection extends ExpandableListSection<FlightTag> {
  final WidgetRef ref;
  final AirportPositionSection airportPositionSection;
  final List<FlightTag> tags;

  AirportSectionTagSection({required this.airportPositionSection, required this.tags, required this.ref});

  @override
  List<FlightTag>? getItems() {
    List<FlightTag> items = tags.where((c) => c.sectionID == airportPositionSection.id).toList();
    return items;
  }

  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedAirportSectionsTag);
    return !expandeds.contains(airportPositionSection.id);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedAirportSectionsTag.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [airportPositionSection.id];
    } else {
      expandeds.state = expandeds.state.where((element) => element != airportPositionSection.id).toList();
    }
  }

  List<FlightTag> get items {
    return getItems() ?? [];
  }

  bool get isShow {
    return items.isNotEmpty || airportPositionSection.showEmpty;
  }
}

class AirportSectionContainerSection extends ExpandableListSection<TagContainer> {
  final WidgetRef ref;
  final AirportPositionSection airportPositionSection;
  final List<TagContainer> cons;

  AirportSectionContainerSection({required this.airportPositionSection, required this.cons, required this.ref});



  @override
  List<TagContainer>? getItems() {
    List<TagContainer> items = cons.where((c) => c.sectionID == airportPositionSection.id).toList();
    return items;
  }

  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedAirportSectionsContainer);
    return !expandeds.contains(airportPositionSection.id);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedAirportSectionsContainer.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [airportPositionSection.id];
    } else {
      expandeds.state = expandeds.state.where((element) => element != airportPositionSection.id).toList();
    }
  }

  List<TagContainer> get items {
    return getItems() ?? [];
  }

  bool get isShow => cons.isNotEmpty  || airportPositionSection.showEmpty;
}

class AirportSectionBinSection extends ExpandableListSection<Bin> {
  final WidgetRef ref;
  final AirportPositionSection airportPositionSection;
  final List<Bin> bins;

  AirportSectionBinSection({required this.airportPositionSection, required this.bins, required this.ref});



  @override
  List<Bin>? getItems() {
    List<Bin> items = bins.where((b) => b.sectionID == airportPositionSection.id).toList();
    return items;
  }

  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedAirportSectionsBin);
    return !expandeds.contains(airportPositionSection.id);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedAirportSectionsBin.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [airportPositionSection.id];
    } else {
      expandeds.state = expandeds.state.where((element) => element != airportPositionSection.id).toList();
    }
  }

  List<Bin> get items {
    return getItems() ?? [];
  }

  bool get isShow => bins.isNotEmpty || airportPositionSection.showEmpty;
}

// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
// import '../../../../core/classes/flight_details_class.dart';
// import '../../../../core/classes/tag_container_class.dart';
// import '../../flight_details_state.dart';
//
// class BinSection extends ExpandableListSection<TagContainer> {
//   final WidgetRef ref;
//   final Bin bin;
//   final List<TagContainer> allCons;
//   final FlightDetails fd;
//
//   BinSection({required this.bin, required this.allCons, required this.ref, required this.fd});
//
//   @override
//   List<TagContainer>? getItems() {
//     List<TagContainer> results = [];
//     if (fd.tagList.any((element) => element.getContainerID == null && element.tagPositions.first.binID == bin.id)) {
//       results = allCons
//               .where((element) => element.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty)
//               .toList() +
//           [TagContainer.bulk(2)];
//     } else {
//       results = allCons
//           .where((element) => element.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty)
//           .toList();
//     }
//
//     // results =  results.where((e) =>(e.isBulk || e.getTags(fd).isNotEmpty) && e.getTags(fd).any((element) {
//     //   // print(element.tagPositions.first.binID==bin.id);
//     //   return true;
//     //   return   element.tagPositions.first.binID==bin.id;
//     // })).toList();
//     return results;
//   }
//
//   @override
//   bool isSectionExpanded() {
//     List<int> expandeds = ref.watch(expandedBins);
//     return !expandeds.contains(bin.id);
//   }
//
//   @override
//   void setSectionExpanded(bool expanded) {
//     final expandeds = ref.watch(expandedBins.notifier);
//     if (!expanded) {
//       expandeds.state = expandeds.state + [bin.id!];
//     } else {
//       expandeds.state = expandeds.state.where((element) => element != bin.id).toList();
//     }
//   }
//
//   List<TagContainer> get items {
//     return getItems()!;
//   }
// }

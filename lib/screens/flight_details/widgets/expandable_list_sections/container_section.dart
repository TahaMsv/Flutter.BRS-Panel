// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
// import '../../../../core/classes/flight_details_class.dart';
// import '../../../../core/classes/login_user_class.dart';
// import '../../../../core/classes/tag_container_class.dart';
// import '../../flight_details_state.dart';
//
// class ContainerSection extends ExpandableListSection<FlightTag> {
//   final WidgetRef ref;
//   final TagContainer con;
//   final List<FlightTag> allTags;
//
//   ContainerSection({required this.con, required this.allTags, required this.ref});
//
//   @override
//   List<FlightTag>? getItems() {
//     Position? selectedPos = ref.watch(selectedPosInDetails);
//
//     List<FlightTag> itms =
//         allTags.where((element) => selectedPos == null || selectedPos.id == element.currentPosition).where((element) {
//       return ((selectedPos == null || element.currentPosition == selectedPos.id) &&
//               element.tagPositions.first.container?.id == con.id) ||
//           (element.tagPositions.first.container?.id == null && con.isCart);
//     }).toList();
//     return itms;
//   }
//
//   @override
//   bool isSectionExpanded() {
//     List<int> expandeds = ref.watch(expandedContainers);
//     return !expandeds.contains(con.id);
//   }
//
//   @override
//   void setSectionExpanded(bool expanded) {
//     final expandeds = ref.watch(expandedContainers.notifier);
//     if (!expanded) {
//       expandeds.state = expandeds.state + [con.id!];
//     } else {
//       expandeds.state = expandeds.state.where((element) => element != con.id).toList();
//     }
//   }
//
//   List<FlightTag> get items {
//     Position? selectedPos = ref.watch(selectedPosInDetails);
//     return allTags.where((element) {
//       // if(element.tagPositions.first.container?.id==null){
//       //   return con.isBulk;
//       // }else{
//       //   element.tagPositions.first.container!.id == con.id;
//       // }
//       return (selectedPos == null || selectedPos.id == element.currentPosition) &&
//               element.tagPositions.first.container?.id == con.id ||
//           (element.tagPositions.first.container?.id == null && con.isCart);
//     }).toList();
//   }
//
//   bool get isBulk => con.isCart;
// }

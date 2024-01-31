import 'package:flutter/material.dart';
import '../../../../core/classes/flight_details_class.dart';
import '../../../../core/classes/login_user_class.dart';
import '../../../../core/classes/tag_container_class.dart';
import '../../../../core/constants/ui.dart';
import '../../../../core/util/basic_class.dart';
import '../../../../widgets/MyExpansionTile2.dart';
import '../../flight_details_view.dart';

class SortTableBuilder extends StatelessWidget {
  const SortTableBuilder({super.key, required this.fd, required this.tags, required this.cons});

  final FlightDetails fd;
  final List<TagContainer> cons;
  final List<FlightTag> tags;

  @override
  Widget build(BuildContext context) {
    final List<AirportPositionSection> positionSections = BasicClass.getAllAirportSections();
    List<AirportPositionSection> showSections = positionSections.where((s) => cons.any((c) => c.sectionID == s.id) || tags.any((c) => c.sectionID == s.id)).toList();
    return Column(
      children: showSections.map(
        (sec) {
          int indexS = showSections.indexOf(sec);
          List<TagContainer> secCons = cons.where((c) => c.sectionID == sec.id).toList();
          List<FlightTag> secTags = tags.where((t) => t.getContainerID == null && t.sectionID == sec.id).toList();
          int tagCount = secTags.length + tags.where((t) => secCons.any((c) => t.getContainerID == c.id)).toList().length;
          return MyExpansionTile2(
            title: SectionTileWidget(label: sec.label, tagCount: tagCount),
            showLeadingIcon: true,
            showIcon: false,
            childrenPadding: EdgeInsets.zero,
            iconColor: MyColors.brownGrey5,
            collapsedIconColor: MyColors.brownGrey5,
            backgroundColor: indexS.isEven ? MyColors.sectionGrey : MyColors.sectionGrey2,
            children: [
              ...secCons.map((con) {
                int indexC = secCons.indexOf(con);
                List<FlightTag> conTags = tags.where((t) => con.id == t.getContainerID).toList();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyExpansionTile2(
                      title: ContainerTileWidget(isFirstSec: false, binLines: false, con: con, items: conTags, isLast: false, tagCount: conTags.length),
                      showLeadingIcon: true,
                      showIcon: false,
                      initiallyExpanded: false,
                      childrenPadding: EdgeInsets.zero,
                      iconColor: MyColors.brownGrey5,
                      collapsedIconColor: MyColors.brownGrey5,
                      backgroundColor: !(con.isActive ?? true)
                          ? indexC.isEven
                              ? MyColors.disabledContainerGreen
                              : MyColors.disabledContainerGreen2
                          : indexC.isEven
                              ? MyColors.containerGreen
                              : MyColors.containerGreen2,
                      children: conTags.map((e) => TagWidget(tag: e, fd: fd, total: conTags.length, index: conTags.indexOf(e), hasBinLine: false, isLast: conTags.last == e)).toList(),
                    ),
                  ],
                );
              }),
              ...secTags.map((e) => TagWidget(tag: e, fd: fd, total: secTags.length, index: secTags.indexOf(e), hasBinLine: false, isLast: secTags.last == e)),
            ],
          );
        },
      ).toList(),
    );
  }
}

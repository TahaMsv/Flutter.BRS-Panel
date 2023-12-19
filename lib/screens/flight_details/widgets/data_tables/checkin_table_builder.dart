import 'package:flutter/material.dart';
import '../../../../core/classes/flight_details_class.dart';
import '../../../../core/classes/login_user_class.dart';
import '../../../../core/classes/tag_container_class.dart';
import '../../../../core/constants/ui.dart';
import '../../../../core/util/basic_class.dart';
import '../../../../widgets/MyExpansionTile2.dart';
import '../../flight_details_view.dart';

class CheckinTableBuilder extends StatelessWidget {
  const CheckinTableBuilder({super.key, required this.fd, required this.tags});

  final FlightDetails fd;
  final List<FlightTag> tags;

  @override
  Widget build(BuildContext context) {
    final List<AirportPositionSection> positionSections = BasicClass.getAllAirportSections();
    List<AirportPositionSection> showSections = positionSections.where((s) => tags.any((t) => t.sectionID == s.id)).toList();
    return Column(
      children: showSections.map(
        (sec) {
          int indexS = showSections.indexOf(sec);
          List<FlightTag> secTags = tags.where((t) => t.getContainerID == null && t.sectionID == sec.id).toList();
          int tagCount = tags.where((t) => t.sectionID == sec.id).toList().length;
          return MyExpansionTile2(
            title: SectionTileWidget(label: sec.label, tagCount: tagCount),
            showLeadingIcon: true,
            showIcon: false,
            childrenPadding: EdgeInsets.zero,
            iconColor: MyColors.brownGrey5,
            collapsedIconColor: MyColors.brownGrey5,
            backgroundColor: indexS.isEven ? MyColors.sectionGrey : MyColors.sectionGrey2,
            children: secTags.map((tag) {
              int indexT = secTags.indexOf(tag);
              return TagWidget(tag: tag, index: indexT, fd: fd, total: secTags.length, hasBinLine: false, hasTagLine: false);
            }).toList(),
          );
        },
      ).toList(),
    );
  }
}

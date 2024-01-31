import 'package:flutter/material.dart';
import '../../../../core/classes/flight_details_class.dart';
import '../../../../core/classes/login_user_class.dart';
import '../../../../core/classes/tag_container_class.dart';
import '../../../../core/constants/ui.dart';
import '../../../../core/util/basic_class.dart';
import '../../../../widgets/MyExpansionTile2.dart';
import '../../flight_details_view.dart';

class LoadTableBuilder extends StatelessWidget {
  const LoadTableBuilder({super.key, required this.fd, required this.tags, required this.cons, required this.bins});

  final FlightDetails fd;
  final List<Bin> bins;
  final List<TagContainer> cons;
  final List<FlightTag> tags;

  @override
  Widget build(BuildContext context) {
    final List<AirportPositionSection> positionSections = BasicClass.getAllAirportSections();
    List<AirportPositionSection> showSections =
        positionSections.where((s) => bins.any((b) => b.sectionID == s.id) || cons.any((c) => c.sectionID == s.id) || tags.any((t) => t.sectionID == s.id)).toList();
    return Column(
      children: showSections.map(
        (sec) {
          int indexS = showSections.indexOf(sec);
          List<Bin> secBins = bins.where((b) => b.sectionID == sec.id).toList();
          List<TagContainer> secCons = cons.where((c) => c.binID == null && c.sectionID == sec.id).toList();
          List<FlightTag> secTags = tags.where((t) => t.binID == null && t.getContainerID == null && t.sectionID == sec.id).toList();
          int tagCount = tags.where((t) => t.sectionID == sec.id).toList().length;
          return MyExpansionTile2(
            title: SectionTileWidget(label: sec.label, tagCount: tagCount),
            showLeadingIcon: true,
            showIcon: false,
            childrenPadding: EdgeInsets.zero,
            iconColor: MyColors.brownGrey5,
            collapsedIconColor: MyColors.brownGrey5,
            backgroundColor: indexS.isEven ? MyColors.sectionGrey : MyColors.sectionGrey2,
            children: [
              ...secBins.map((bin) {
                int indexB = secBins.indexOf(bin);
                List<TagContainer> binCons = cons.where((c) => c.type == "ULD" && c.binID == bin.id).toList();
                List<FlightTag> binTags = tags.where((t) => !binCons.any((c) => c.id == t.getContainerID) && t.binID == bin.id).toList();
                int tagCount = binTags.length + tags.where((t) => binCons.any((c) => c.id == t.getContainerID)).toList().length;
                return MyExpansionTile2(
                  title: BinTileWidget(tagCount: tagCount, isFirstSec: false, bin: bin, items: binCons),
                  showIcon: false,
                  showLeadingIcon: true,
                  iconColor: MyColors.white3,
                  collapsedIconColor: MyColors.white3,
                  childrenPadding: EdgeInsets.zero,
                  backgroundColor: indexB.isEven ? MyColors.binGrey : MyColors.binGrey2,
                  children: [
                    ...binCons.map((con) {
                      int indexC = binCons.indexOf(con);
                      List<FlightTag> conTags = tags.where((t) => t.getContainerID == con.id).toList();
                      return MyExpansionTile2(
                        title: ContainerTileWidget(isLast: binCons.last == con, binLines: true, con: con, items: conTags, isFirstSec: false, tagCount: conTags.length),
                        showIcon: false,
                        showLeadingIcon: true,
                        iconColor: MyColors.white3,
                        collapsedIconColor: MyColors.white3,
                        childrenPadding: EdgeInsets.zero,
                        backgroundColor: !(con.isActive ?? true)
                            ? indexC.isEven
                                ? MyColors.disabledContainerGreen
                                : MyColors.disabledContainerGreen2
                            : indexC.isEven
                                ? MyColors.containerGreen
                                : MyColors.containerGreen2,
                        children: conTags.map((tag) {
                          return TagWidget(
                            tag: tag,
                            fd: fd,
                            total: conTags.length,
                            index: conTags.indexOf(tag),
                            hasBinLine: !(binCons.last == con),
                            isLast: conTags.last == tag,
                            alterColor: true,
                          );
                        }).toList(),
                      );
                    }),
                    ...binTags.map((tag) {
                      int indexT = binTags.indexOf(tag);
                      return TagWidget(tag: tag, index: indexT, hasBinLine: !(binTags.last == tag), total: binTags.length, fd: fd);
                    }),
                  ],
                );
              }),
              ...secCons.map((con) {
                int indexC = secCons.indexOf(con);
                List<FlightTag> conTags = tags.where((t) => t.getContainerID == con.id).toList();
                return MyExpansionTile2(
                  title: ContainerTileWidget(isLast: secCons.last == con, binLines: true, con: con, items: conTags, isFirstSec: false, tagCount: conTags.length),
                  showIcon: false,
                  showLeadingIcon: true,
                  iconColor: MyColors.white3,
                  collapsedIconColor: MyColors.white3,
                  childrenPadding: EdgeInsets.zero,
                  backgroundColor: !(con.isActive ?? true)
                      ? indexC.isEven
                          ? MyColors.disabledContainerGreen
                          : MyColors.disabledContainerGreen2
                      : indexC.isEven
                          ? MyColors.containerGreen
                          : MyColors.containerGreen2,
                  children: conTags.map((tag) {
                    return TagWidget(
                      tag: tag,
                      fd: fd,
                      total: conTags.length,
                      index: conTags.indexOf(tag),
                      hasBinLine: !(secCons.last == con),
                      isLast: conTags.last == tag,
                      alterColor: true,
                    );
                  }).toList(),
                );
              }),
              ...secTags.map((tag) {
                int indexT = secTags.indexOf(tag);
                return TagWidget(tag: tag, index: indexT, hasBinLine: !(secTags.last == tag), total: secTags.length, fd: fd);
              }),
            ],
          );
        },
      ).toList(),
    );
  }
}

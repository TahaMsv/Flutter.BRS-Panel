import 'dart:convert';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/flight_details/flight_details_view.dart';
import 'package:brs_panel/widgets/MyExpansionTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import '../core/classes/flight_class.dart';
import '../core/classes/flight_details_class.dart';
import '../core/classes/tag_more_details_class.dart';
import '../core/classes/login_user_class.dart';
import '../core/constants/ui.dart';
import '../screens/flight_details/flight_details_controller.dart';
import '../screens/flight_details/flight_details_state.dart';
import '../screens/flight_details/widgets/expandable_list_sections/airport_section.dart';
import 'AirlineLogo.dart';
import 'CardField.dart';
import 'DotButton.dart';
import 'FlightBanner.dart';
import 'MyButton.dart';
import 'MyExpansionTile2.dart';
import 'dart:math' as math;

class TagDetailsDialog extends ConsumerStatefulWidget {
  final FlightTag tag;
  final TagMoreDetails moreDetails;

  // final List<TagPhoto> photos;

  const TagDetailsDialog({Key? key, required this.tag, required this.moreDetails}) : super(key: key);

  @override
  _TagDetailsDialogState createState() => _TagDetailsDialogState();
}

class _TagDetailsDialogState extends ConsumerState<TagDetailsDialog> {
  late FlightTag tag;
  late TagMoreDetails moreDetails;
  List<TagPhoto> photos = [];
  int loadingAction = -1;
  bool showActions = true;
  late List<Uint8List> photosBytes;

  @override
  void initState() {
    tag = widget.tag;
    moreDetails = widget.moreDetails;
    photos = widget.moreDetails.tagPhotos;
    photosBytes = photos.map((e) => base64Decode(e.photo)).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NewSection> secList = [
      NewSection(label: "Specials", ref: ref, position: 0),
      NewSection(label: "Inbound", ref: ref, position: 1),
      NewSection(label: "onward", ref: ref, position: 2),
      NewSection(label: "Position Log", ref: ref, position: 3),
      NewSection(label: "Status Log", ref: ref, position: 4),
      NewSection(label: "BSM", ref: ref, position: 5),
    ];
    ThemeData theme = Theme.of(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<int> blockedPositions = tag.actionsHistory.isEmpty ? [] : tag.actionsHistory.first.blockedPosition;
    TagStatus status = tag.status;
    Flight f = ref.watch(selectedFlightProvider)!;
    FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();

    TextStyle tagNumStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: tag.isForced
            ? MyColors.havaPrime
            : tag.currentStatus > 0
                ? tag.exception?.getColor
                : MyColors.black1);
    FlightInfo? fInfo = widget.moreDetails.flightInfo;
    // print(tag.inboundLeg);
    // print(tag.outboundLegs.map((e) => e.type));
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.05),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        child: Container(
          constraints: BoxConstraints(
            minWidth: width,
            // minHeight: height * 0.9,
            maxHeight: height * 0.7,
          ),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(tag.numString, style: tagNumStyle),
                        const SizedBox(width: 15),
                        SizedBox(
                          height: 20,
                          child: tag.getTypeWidget,
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 25,
                          child: tag.getStatusWidget,
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 25,
                          child: tag.getInboundWidget,
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 25,
                          child: tag.getOutboundWidget,
                        ),
                        const SizedBox(width: 30),
                        if (tag.isGateTag)
                          Transform.rotate(
                            angle: -90 * math.pi / 180,
                            child: tag.getGateWidget,
                          ),
                        const SizedBox(width: 5),
                        const Row(
                          children: [
                            Icon(size: 12, Icons.shield, color: Colors.grey),
                            Text("14", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        const SizedBox(width: 5),
                        const Row(
                          children: [
                            Icon(size: 12, Icons.shopping_bag, color: Colors.grey),
                            Text("5", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlightBanner(
                          flight: f,
                          bgColor: Colors.black12,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${tag.getAddress} (${tag.tagPositions.first.indexInPosition})",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(tag.tagPositions.first.getTime()),
                        const SizedBox(width: 10),
                        DotButton(
                          size: 25,
                          icon: Icons.refresh,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          size: 20,
                          Icons.refresh,
                          color: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                const SizedBox(height: 20),
                DcsInfoWidget(info: tag.dcsInfo),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    itemCount: secList.length,
                    itemBuilder: (context, index) {
                      return MyExpansionTile(
                        disableOnTap: index == 0 || index == 2,
                        trailing: Container(),
                        onExpansionChanged: (bool isExpanded) {
                          secList[index].setSectionExpanded(isExpanded);
                        },
                        headerTileColor: index % 2 == 0 ? MyColors.oddRow : MyColors.evenRow,
                        title: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                          ),
                          child: SectionTileWidget2(
                            secTag: secList[index],
                            iconData: Icons.star_border_rounded,
                            tag: tag,
                            f: f,
                          ),
                        ),
                        children: index == 1
                            ? []
                            : index == 3
                                ? [
                                      const ExpansionListItem(
                                        texts: ["Time", "User", "Position/Order", "Details"],
                                        isBold: true,
                                        bgColor: MyColors.evenRow,
                                      )
                                    ] +
                                    tag.tagPositions.asMap().entries.map((t) {
                                      var index = t.key;
                                      TagPosition value = t.value;

                                      return ExpansionListItem(
                                          texts: [value.dateUtc.format_yyyyMMdd.toString(), value.username, value.positionId.toString(), value.positionDesc ?? '-'],
                                          isBold: false,
                                          bgColor: index % 2 == 0 ? MyColors.oddRow : MyColors.evenRow); //todo correct values?
                                    }).toList()
                                : index == 4
                                    ? [
                                          const ExpansionListItem(
                                            texts: ["Time", "User", "Number", "Status"],
                                            isBold: true,
                                            bgColor: MyColors.evenRow,
                                          )
                                        ] + //todo correct values?
                                        tag.actionsHistory.asMap().entries.map((t) {
                                          var index = t.key;
                                          ActionHistory value = t.value;
                                          return ExpansionListItem(
                                              texts: [value.actionTime, value.username, value.positionId.toString(), BasicClass.getTagStatusByID(value.tagStatus)?.title ?? ""],
                                              isBold: false,
                                              bgColor: index % 2 == 0 ? MyColors.oddRow : MyColors.evenRow);
                                        }).toList()
                                    : moreDetails.bsmList.asMap().entries.map((t) {
                                        var index = t.key;
                                        Bsm value = t.value;
                                        return BSMMessage(bsm: value);
                                      }).toList(),

                        // subtitle: Text("Data"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BSMMessage extends StatelessWidget {
  const BSMMessage({
    super.key,
    required this.bsm,
  });

  final Bsm bsm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              // height: 50,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), // radius of 10
                color: MyColors.greyishBrown,
              ),
              child: Row(
                children: [
                  Text(
                    bsm.bsmMessage,
                    style: const TextStyle(color: MyColors.green),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class ExpansionListItem extends StatelessWidget {
  const ExpansionListItem({
    super.key,
    required this.texts,
    required this.isBold,
    required this.bgColor,
  });

  final List<String> texts;
  final bool isBold;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    FontWeight fw = isBold ? FontWeight.bold : FontWeight.w600;
    return Container(
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 800,
            height: 50,
            // color: bgColor,
            // padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 1, child: Center(child: Text(texts[0], style: TextStyle(color: MyColors.greyishBrown, fontSize: 12, fontWeight: fw)))),
                Expanded(flex: 1, child: Center(child: Text(texts[1], style: TextStyle(color: MyColors.greyishBrown, fontSize: 12, fontWeight: fw)))),
                Expanded(flex: 1, child: Center(child: Text(texts[2], style: TextStyle(color: MyColors.greyishBrown, fontSize: 12, fontWeight: fw)))),
                Expanded(flex: 1, child: Center(child: Text(texts[3], style: TextStyle(color: MyColors.greyishBrown, fontSize: 12, fontWeight: fw)))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DcsInfoWidget extends StatelessWidget {
  final DcsInfo? info;

  const DcsInfoWidget({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (info == null) {
      return Row(children: [
        HorizontalCardField(title: "Pax", value: info!.paxId.toString()),
        const SizedBox(width: 70),
        HorizontalCardField(title: "PNR", value: info!.pnr),
        const SizedBox(width: 70),
        HorizontalCardField(title: "P/W", value: "${info!.count}/${info!.weight}"),
        const SizedBox(width: 70),
        HorizontalCardField(title: "Dest", value: info!.dest),
        const SizedBox(width: 70),
        const HorizontalCardField(title: "Photo", valueWidget: Icon(Icons.camera_alt, color: Colors.blue), value: "-"),
      ]);
    }
    return Row(children: [
      HorizontalCardField(
        title: "Pax",
        widgetPadding: EdgeInsets.zero,
        valueWidget: GestureDetector(
          onTap: () {},
          child: Text(
            "${info!.paxName}",
            style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(width: 70),
      HorizontalCardField(title: "PNR", value: info!.pnr),
      const SizedBox(width: 70),
      HorizontalCardField(title: "P/W", value: "${info!.count}/${info!.weight}"),
      const SizedBox(width: 70),
      HorizontalCardField(title: "Dest", value: "${info!.dest}"),
      const SizedBox(width: 70),
      const HorizontalCardField(title: "Photo", valueWidget: Icon(Icons.add_a_photo_outlined, color: Colors.blue), value: "-"),
    ]);
  }
}

class SectionTileWidget2 extends StatelessWidget {
  const SectionTileWidget2({
    super.key,
    required this.iconData,
    required this.secTag,
    required this.tag,
    required this.f,
  });

  final IconData iconData;
  final NewSection? secTag;
  final FlightTag tag;
  final Flight f;

  @override
  Widget build(BuildContext context) {
    return secTag!.position == 0
        ? SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(iconData),
                    ),
                    Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 80),
                    SizedBox(height: 20, child: tag.getTypeWidget),
                    const SizedBox(width: 12),
                  ] +
                  tag.tagSsrs.asMap().entries.map((t) {
                    var index = t.key;
                    TagSSR value = t.value;
                    return tag.getTagSsrsWidget(value.name)!;
                  }).toList(),
            ),
          )
        : secTag!.position == 2
            ? SizedBox(
                height: 60,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(iconData),
                          ),
                          Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 80),
                        ] +
                        (tag.outboundLegs.isEmpty
                            ? []
                            : [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: AirlineLogo(
                                    tag.outboundLegs.first.al,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(width: 70),
                                HorizontalCardField(title: "AL", value: tag.outboundLegs.first.al),
                                const SizedBox(width: 70),
                                HorizontalCardField(title: "FLNB", value: tag.outboundLegs.first.flnb),
                                const SizedBox(width: 70),
                                HorizontalCardField(title: "Date", value: DateFormat("dd MMM").format(tag.outboundLegs.first.flightDate)),
                                const SizedBox(width: 70),
                                HorizontalCardField(title: "City", value: tag.outboundLegs.first.city),
                              ])),
              )
            : Container(
                color: secTag!.position % 2 == 0 ? MyColors.oddRow : MyColors.evenRow,
                height: 60,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(secTag!.isSectionExpanded() ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(iconData),
                    ),
                    Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
  }
}

class NewSection {
  final WidgetRef ref;
  String label;
  final int position;

  NewSection({
    required this.ref,
    required this.label,
    required this.position,
  });

  // @override
  // List<int>? getItems() {
  //   return [0, 1, 2];
  // }

  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedTagDetailsDialog);
    return !expandeds.contains(position);
  }

  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedTagDetailsDialog.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [position];
    } else {
      expandeds.state = expandeds.state.where((element) => element != position).toList();
    }
  }

// List<int> get items {
//   return getItems() ?? [];
// }
}

// class TagLogsWidget extends StatelessWidget {
//   final List<TagLog> logs;
//
//   const TagLogsWidget({Key? key, required this.logs}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (logs.every((element) => element.title.trim().isEmpty)) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Text("Logs", style: TextStyle(fontWeight: FontWeight.bold)),
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: const BoxDecoration(color: Colors.grey),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: logs
//                 .map((e) => Row(
//                       children: [
//                         Expanded(
//                             child: Text(
//                           e.title,
//                           style: GoogleFonts.inconsolata(fontSize: 16),
//                         )),
//                       ],
//                     ))
//                 .toList(),
//           ),
//         )
//       ],
//     );
//   }
// }
// class TagSSRListWidget extends StatelessWidget {
//   final List<TagSSR> ssrs;
//
//   const TagSSRListWidget({Key? key, required this.ssrs}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (ssrs.isEmpty) return const SizedBox();
//     return MyExpansionTile2(
//       initiallyExpanded: true,
//       title: const Row(
//         children: [
//           Text("Specials", style: TextStyle(fontWeight: FontWeight.bold)),
//           Icon(
//             Icons.star_purple500,
//             color: Colors.deepOrange,
//           )
//         ],
//       ),
//       children: [
//         SizedBox(
//           width: width,
//           child: Wrap(
//             alignment: WrapAlignment.start,
//             runSpacing: 4,
//             children: ssrs
//                 .map((e) => Container(
//                       margin: const EdgeInsets.only(right: 4),
//                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                       decoration: BoxDecoration(color: MyColors.myGreen.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
//                       child: Text(
//                         e.name,
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class TagInboundListWidget extends StatelessWidget {
//   final TagLeg? inLeg;
//
//   const TagInboundListWidget({Key? key, required this.inLeg}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (inLeg == null) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Row(
//         children: [
//           Text("Inbound", style: TextStyle(fontWeight: FontWeight.bold)),
//           Icon(Icons.flight_land, color: MyColors.myGreen, size: 20),
//         ],
//       ),
//       children: [
//         Row(children: [
//           AirlineLogo(inLeg!.al),
//           CardField(
//             title: "AL",
//             value: inLeg!.al,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//               child: CardField(
//             title: "FLNB",
//             value: inLeg!.flnb,
//           )),
//           Expanded(child: CardField(title: "Date", value: inLeg!.flightDate.format_ddMMM, scale: 0.8)),
//           Expanded(child: CardField(title: "City", value: inLeg!.city, scale: 0.8)),
//         ]),
//       ],
//     );
//   }
// }
//
// class TagOutboundsWidget extends StatelessWidget {
//   final List<TagLeg> outLegs;
//
//   const TagOutboundsWidget({Key? key, required this.outLegs}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (outLegs.isEmpty) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Row(
//         children: [
//           Text("Onward", style: TextStyle(fontWeight: FontWeight.bold)),
//           Icon(Icons.flight_takeoff, color: MyColors.blueGreen, size: 20),
//         ],
//       ),
//       children: [
//         ...outLegs
//             .map(
//               (e) => Row(children: [
//                 AirlineLogo(e.al),
//                 CardField(
//                   title: "AL",
//                   value: e.al,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                     child: CardField(
//                   title: "FLNB",
//                   value: e.flnb,
//                 )),
//                 Expanded(
//                     child: CardField(
//                   title: "Date",
//                   value: e.flightDate.format_ddMMM,
//                   scale: 0.8,
//                 )),
//                 Expanded(child: CardField(title: "City", value: e.city, scale: 0.8)),
//               ]),
//             )
//             .toList()
//       ],
//     );
//   }
// }
//
// class TagPositionHistoryWidget extends StatelessWidget {
//   final List<TagPosition> positions;
//
//   const TagPositionHistoryWidget({Key? key, required this.positions}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (positions.isEmpty) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Text("Positions Log", style: TextStyle(fontWeight: FontWeight.bold)),
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(flex: 4, child: Text("Time")),
//             Expanded(flex: 5, child: Text("User")),
//             // Expanded(flex: 3, child: Text("Seq.")),
//             Expanded(flex: 9, child: Text("Position/Order")),
//             Expanded(flex: 4, child: Text("Details")),
//           ],
//         ),
//         ...positions.map((e) {
//           int index = positions.indexOf(e);
//           TagPosition tp = e;
//           DateTime? scanTimeUtc = tp.timeUtc.tryDateTimeUTC;
//           // DateTime? scanTime = scanTimeUtc?.toLocal();
//           DateTime? scanTime = BasicClass.getTimeFromUTC(scanTimeUtc);
//           Position tagPos = BasicClass.getPositionById(tp.positionId)!;
//           AirportPositionSection? sec = BasicClass.getAllAirportSections().firstWhereOrNull((element) => element.id == tp.sectionID);
//           if (sec == null) return Container();
//           return Container(
//             color: index % 2 == 0 ? MyColors.paleGrey : Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(flex: 4, child: Text("${scanTime.format_HHmmss}", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Signika"))),
//                 Expanded(flex: 5, child: Text("${tp.username}", overflow: TextOverflow.ellipsis)),
//                 // Expanded(flex: 3, child: Text("${tp.indexInPosition}")),
//                 Expanded(flex: 9, child: Text("${sec.label} / ${tp.indexInPosition}", style: const TextStyle(fontWeight: FontWeight.bold))),
//                 // Expanded(flex: 4, child: Text("${tp.positionId}")),
//                 Expanded(flex: 4, child: Text("${tp.containerCode}")),
//               ],
//             ),
//           );
//         }).toList()
//       ],
//     );
//   }
// }
//
// class TagActionHistoryWidget extends StatelessWidget {
//   final List<ActionHistory> actions;
//
//   const TagActionHistoryWidget({Key? key, required this.actions}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (actions.isEmpty) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Text("Status Log", style: TextStyle(fontWeight: FontWeight.bold)),
//       children: [
//         ...actions.map((e) {
//           ActionHistory ah = e;
//           int index = actions.indexOf(e);
//           DateTime? scanTimeUtc = ah.actionTime.tryDateTimeUTC;
//           DateTime? scanTime = scanTimeUtc?.toLocal();
//           // TagAction tagAction = model.loginUser!.systemSettings.statusActionList.firstWhere((element) => element.id == ah.actionId);
//           TagAction? tagAction = BasicClass.systemSetting.actions.firstWhereOrNull((element) => element.id == ah.actionId);
//           return Container(
//             color: index % 2 == 0 ? MyColors.paleGrey : Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(flex: 5, child: Text("${scanTime.format_HHmmss}", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Signika"))),
//                 Expanded(
//                     flex: 4,
//                     child: Text(
//                       "${ah.username}",
//                       overflow: TextOverflow.ellipsis,
//                     )),
//                 Expanded(flex: 3, child: Text("${ah.id}")),
//                 Expanded(flex: 8, child: Text("${tagAction?.actionTitle ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold))),
//               ],
//             ),
//           );
//         }).toList()
//       ],
//     );
//   }
// }
// class TagBsmsWidget extends StatelessWidget {
//   final List<Bsm> bsmList;
//
//   const TagBsmsWidget({Key? key, required this.bsmList}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     if (bsmList.isEmpty) return const SizedBox();
//     return MyExpansionTile2(
//       title: const Text("BSM ", style: TextStyle(fontWeight: FontWeight.bold)),
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: bsmList
//                 .map((e) => Container(
//               padding: const EdgeInsets.only(bottom: 12),
//               decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54))),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                       child: Text(
//                         e.bsmMessage,
//                         style: GoogleFonts.inconsolata(fontSize: 16),
//                       )),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       DotButton(
//                         size: 40,
//                         onPressed: () async {
//                           await Clipboard.setData(ClipboardData(text: e.bsmMessage));
//                         },
//                         icon: Icons.copy,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         BasicClass.getTimeFromUTC(e.bsmTime).format_HHmmss,
//                         style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ))
//                 .toList(),
//           ),
//         )
//       ],
//     );
//   }
// }

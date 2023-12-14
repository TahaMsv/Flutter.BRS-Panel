import 'dart:convert';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/constants/abomis_pack_icons.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/classes/flight_class.dart';
import '../core/classes/flight_details_class.dart';
import '../core/classes/tag_more_details_class.dart';
import '../core/classes/login_user_class.dart';
import '../core/constants/ui.dart';
import '../core/navigation/navigation_service.dart';
import '../core/util/basic_class.dart';
import '../initialize.dart';
import '../screens/flight_details/flight_details_controller.dart';
import '../screens/flight_details/flight_details_state.dart';
import 'AirlineLogo.dart';
import 'CardField.dart';
import 'DotButton.dart';
import 'FlightBanner.dart';
import 'dart:math' as math;
import 'MyExpansionTile.dart';
import 'PhotoPreviewDialog.dart';

class TagDetailsDialog extends ConsumerStatefulWidget {
  final FlightTag tag;
  final TagMoreDetails moreDetails;

  const TagDetailsDialog({Key? key, required this.tag, required this.moreDetails}) : super(key: key);

  @override
  ConsumerState<TagDetailsDialog> createState() => _TagDetailsDialogState();
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
    final NavigationService nav = getIt<NavigationService>();
    List<NewSection> secList = [
      NewSection(label: "Specials", ref: ref, position: 0, iconData: Icons.star_border_rounded),
      NewSection(label: "Inbound", ref: ref, position: 1, iconData: Icons.flight_land),
      NewSection(label: "onward", ref: ref, position: 2, iconData: Icons.flight_takeoff),
      NewSection(label: "Position Log", ref: ref, position: 3, iconData: AbomisIconPack.report),
      NewSection(label: "Status Log", ref: ref, position: 4, iconData: AbomisIconPack.info),
      NewSection(label: "BSM", ref: ref, position: 5, iconData: Icons.chat),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Material(
        child: Container(
          constraints: BoxConstraints(minWidth: width, maxHeight: height * 0.7),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(tag.numString, style: tagNumStyle),
                          const SizedBox(width: 15),
                          SizedBox(height: 20, child: tag.getTypeWidget),
                          const SizedBox(width: 12),
                          SizedBox(height: 25, child: tag.getStatusWidget),
                          const SizedBox(width: 20),
                          SizedBox(height: 25, child: tag.getInboundWidget),
                          const SizedBox(width: 12),
                          SizedBox(height: 25, child: tag.getOutboundWidget),
                          const SizedBox(width: 30),
                          if (tag.isGateTag) Transform.rotate(angle: -90 * math.pi / 180, child: tag.getGateWidget),

                          // const SizedBox(width: 5),
                          // const Row(
                          //   children: [
                          //     Icon(size: 12, Icons.shield, color: Colors.grey),
                          //     Text("14", style: TextStyle(fontSize: 10)),
                          //   ],
                          // ),
                          // const SizedBox(width: 5),
                          // const Row(
                          //   children: [
                          //     Icon(size: 12, Icons.shopping_bag, color: Colors.grey),
                          //     Text("5", style: TextStyle(fontSize: 10)),
                          //   ],
                          // ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlightBanner(flight: f, bgColor: Colors.black12),
                          const SizedBox(width: 10),
                          Text("${tag.getAddress} (${tag.tagPositions.first.indexInPosition})", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(tag.tagPositions.first.getTime()),
                          const SizedBox(width: 10),
                          IconButton(onPressed: nav.pop, icon: const Icon(Icons.close, color: MyColors.brownGrey)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                const SizedBox(height: 20),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0), child: DcsInfoWidget(info: tag.dcsInfo, moreDetails: moreDetails)),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
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
                            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SectionTileWidget2(secTag: secList[index], tag: tag, f: f),
                            ),
                          ),
                        ),
                        children: index == 1
                            ? []
                            : index == 3
                                ? [
                                      const ExpansionListItem(texts: ["Time", "User", "Position/Order", "Details"], isBold: true, bgColor: MyColors.evenRow)
                                    ] +
                                    tag.tagPositions.asMap().entries.map((t) {
                                      var index = t.key;
                                      TagPosition value = t.value;
                                      AirportPositionSection? sec = BasicClass.getAllAirportSections().firstWhereOrNull((element) => element.id == t.value.sectionID);

                                      return ExpansionListItem(
                                          texts: [value.dateUtc.format_yyyyMMdd.toString(), value.username, "${sec?.label} / ${t.value.indexInPosition}", value.positionDesc ?? '-'],
                                          isBold: false,
                                          bgColor: index % 2 == 0 ? MyColors.oddRow : MyColors.evenRow); //todo correct values?
                                    }).toList()
                                : index == 4
                                    ? [
                                          const ExpansionListItem(texts: ["Time", "User", "Number", "Status"], isBold: true, bgColor: MyColors.evenRow)
                                        ] +
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: MyButton(
                    label: "Delete Tag",
                    width: 120,
                    style: TextButton.styleFrom(backgroundColor: MyColors.white3, foregroundColor: MyColors.brownGrey3, elevation: 0),
                    onPressed: () async => myFlightDetailsController.deleteTag(fInfo?.flightScheduleId ?? f.id, tag),
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
                  color: MyColors.greyishBrown),
              child: Row(
                children: [
                  Text(bsm.bsmMessage, style: const TextStyle(color: MyColors.green)),
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
          SizedBox(
            width: 800,
            height: 50,
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
  late TagMoreDetails moreDetails;

  DcsInfoWidget({Key? key, required this.info, required this.moreDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    late List<Uint8List> photosBytes = moreDetails.tagPhotos.map((e) => base64Decode(e.photo)).toList();

    if (info == null) {
      return Row(children: [
        const HorizontalCardField(title: "Pax", value: ""),
        const SizedBox(width: 70),
        const HorizontalCardField(title: "PNR", value: ""),
        const SizedBox(width: 70),
        const HorizontalCardField(title: "P/W", value: ""),
        const SizedBox(width: 70),
        const HorizontalCardField(title: "Dest", value: ""),
        const SizedBox(width: 70),
        // if (photosBytes.isNotEmpty)
        Expanded(
          child: Row(
              children: photosBytes.asMap().entries.map((b) {
            return InkWell(
              onTap: () async {
                final NavigationService nav = getIt<NavigationService>();
                FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();

                Size imageSize = await myFlightDetailsController.getImageSize(b.value);
                nav.dialog(PhotoPreviewDialog(
                  imageFileBytes: b.value,
                  imageSize: imageSize,
                  pos: null,
                  photoUrl: null,
                ));
              },
              child: Container(
                // color: Colors.red,
                margin: const EdgeInsets.only(right: 20),
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey,
                    width: 44,
                    height: 44,
                    child: Image.memory(b.value),
                  ),
                ),
              ),
            );
          }).toList()),
        ),
      ]);
    }
    return Column(
      children: [
        Row(children: [
          HorizontalCardField(title: "Pax", value: info!.paxName),
          const SizedBox(width: 70),
          HorizontalCardField(title: "SEC", value: info!.securityCode.toString()),
          const SizedBox(width: 70),
          HorizontalCardField(title: "PNR", value: info!.pnr),
          const SizedBox(width: 70),
          HorizontalCardField(title: "P/W", value: "${info!.count}/${info!.weight}"),
          const SizedBox(width: 70),
          HorizontalCardField(title: "Dest", value: info!.dest),
          const SizedBox(width: 70),
          Expanded(
            child: Row(
                children: photosBytes.asMap().entries.map((b) {
              return InkWell(
                onTap: () async {
                  final NavigationService nav = getIt<NavigationService>();
                  FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();
                  Size imageSize = await myFlightDetailsController.getImageSize(b.value);
                  nav.dialog(PhotoPreviewDialog(
                    imageFileBytes: b.value,
                    imageSize: imageSize,
                    pos: null,
                    photoUrl: null,
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey,
                      width: 44,
                      height: 44,
                      child: Image.memory(b.value),
                    ),
                  ),
                ),
              );
            }).toList()),
          ),
        ]),
        // Row(
        //   children: [
        //     HorizontalCardField(title: "Pax", value: info!.),
        //     const SizedBox(width: 70),
        //   ],
        // )
      ],
    );
  }
}

class SectionTileWidget2 extends StatelessWidget {
  const SectionTileWidget2({
    super.key,
    required this.secTag,
    required this.tag,
    required this.f,
  });

  final NewSection? secTag;
  final FlightTag tag;
  final Flight f;

  @override
  Widget build(BuildContext context) {
    return secTag!.position == 0
        ? Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    Icon(secTag!.iconData),
                    const SizedBox(width: 8),
                    Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 80),
                    SizedBox(height: 20, child: tag.getTypeWidget),
                    const SizedBox(width: 12),
                  ] +
                  tag.tagSsrs.asMap().entries.map((t) {
                    TagSSR value = t.value;
                    return tag.getTagSsrsWidget(value.name)!;
                  }).toList(),
            ),
          )
        : secTag!.position == 2
            ? Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                        Icon(secTag!.iconData),
                        const SizedBox(width: 8),
                        Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 80),
                      ] +
                      (tag.outboundLegs.isEmpty
                          ? []
                          : [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: AirlineLogo(tag.outboundLegs.first.al, size: 50),
                              ),
                              const SizedBox(width: 70),
                              HorizontalCardField(title: "AL", value: tag.outboundLegs.first.al),
                              const SizedBox(width: 70),
                              HorizontalCardField(title: "FLNB", value: tag.outboundLegs.first.flnb),
                              const SizedBox(width: 70),
                              HorizontalCardField(title: "Date", value: DateFormat("dd MMM").format(tag.outboundLegs.first.flightDate)),
                              const SizedBox(width: 70),
                              HorizontalCardField(title: "City", value: tag.outboundLegs.first.city),
                            ]),
                ),
              )
            : Container(
                color: secTag!.position % 2 == 0 ? MyColors.oddRow : MyColors.evenRow,
                height: 60,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(secTag!.iconData),
                        const SizedBox(width: 8),
                        Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(secTag!.isSectionExpanded() ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
                  ],
                ),
              );
  }
}

class NewSection {
  final WidgetRef ref;
  String label;
  IconData iconData;
  final int position;

  NewSection({required this.ref, required this.label, required this.position, required this.iconData});

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

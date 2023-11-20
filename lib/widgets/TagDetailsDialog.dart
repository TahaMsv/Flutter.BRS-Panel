import 'dart:convert';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/flight_details/flight_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/classes/flight_class.dart';
import '../core/classes/flight_details_class.dart';
import '../core/classes/tag_more_details_class.dart';
import '../core/classes/login_user_class.dart';
import '../core/constants/ui.dart';
import '../screens/flight_details/flight_details_controller.dart';
import '../screens/flight_details/flight_details_state.dart';
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
  List<TagPhoto> photos = [];
  int loadingAction = -1;
  bool showActions = true;
  late List<Uint8List> photosBytes;

  @override
  void initState() {
    tag = widget.tag;
    photos = widget.moreDetails.tagPhotos;
    photosBytes = photos.map((e) => base64Decode(e.photo)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
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
      // margin: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.05),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        child: Container(
          constraints: BoxConstraints(
            minWidth: width,
            // minHeight: height * 0.9,
            maxHeight: height * 0.7,
          ),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(25),
            //   topRight: Radius.circular(25),
            // ),
          ),
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
                        Text(
                          tag.numString,
                          style: tagNumStyle,
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          height: 20,
                          child: tag.getTypeWidget,
                        ),
                        const SizedBox(width: 12),
                        tag.getTahaWidget(
                          "Deny Load",
                          Colors.red,
                        ),
                        const SizedBox(width: 20),
                        tag.getTahaWidget("Inbound", Colors.green),
                        const SizedBox(width: 12),
                        tag.getTahaWidget("Onward", Colors.blue),
                        const SizedBox(width: 30),
                        Transform.rotate(
                          angle: -90 * math.pi / 180,
                          child: tag.getTahaWidget("GATE", Colors.green),
                        ),
                        // const SizedBox(width: 5),
                        const Row(
                          children: [
                            Icon(
                              size: 15,
                              Icons.shield,
                              color: Colors.grey,
                            ),
                            Text("14"),
                          ],
                        ),
                        const SizedBox(width: 5),
                        const Row(
                          children: [
                            Icon(
                              size: 15,
                              Icons.shopping_bag,
                              color: Colors.grey,
                            ),
                            Text("5"),
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
                        const Text("Checkb-in (76)", style: TextStyle(fontWeight: FontWeight.bold)),
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

                    // inDetails
                    //     ? const SizedBox()
                    //     : SizedBox(
                    //   height: 40,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       DotButton(
                    //         icon: Icons.info,
                    //         size: 20,
                    //         onPressed: () async {
                    //           FlightDetailsController fd = getIt<FlightDetailsController>();
                    //           await fd.flightGetTagMoreDetails(tag.flightScheduleId, tag);
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    // const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                SizedBox(height: 20),
                DcsInfoWidget(info: tag.dcsInfo),
                SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),

                // const Divider(thickness: 1, height: 1),
                // fInfo == null
                //     ? const SizedBox()
                //     : Row(
                //         children: [
                //           AirlineLogo(fInfo.al, size: 75),
                //           Expanded(
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     Expanded(
                //                       flex: 3,
                //                       child: Text(
                //                         fInfo.flightNumber,
                //                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //                       ),
                //                     ),
                //                     Expanded(flex: 2, child: CardField(title: "Route", value: fInfo.route, scale: 0.7)),
                //                   ],
                //                 ),
                //                 const SizedBox(height: 8),
                //                 Row(
                //                   children: [
                //                     // Expanded(flex: 2, child: CardField(title: "Route", value: fInfo.route, scale: 0.7)),
                //                     Expanded(
                //                       flex: 3,
                //                       child: CardField(
                //                           title: "Date Time",
                //                           value: "${fInfo.flightDate.format_ddMMM} ${fInfo.std}",
                //                           scale: 0.7),
                //                     ),
                //                     Expanded(
                //                         flex: 2,
                //                         child: CardField(title: "Registration", value: fInfo.register ?? "", scale: 0.7)),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                // const Divider(height: 1),
                // Expanded(
                //     child: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                //   child: Column(
                //     children: [
                //       // Row(
                //       //   children: [
                //       //     Expanded(flex: 3, child: CardField(title: "Position / Order", value: "${currentP.title} / ${tag.tagPositions.first.indexInPosition}")),
                //       //     // Expanded(child: CardField(title: "Seq. Flight", value: "${tag.indexInFlight}")),
                //       //     Expanded(child: CardField(title: "Pax Seq", value: "${tag.dcsInfo?.securityCode ?? '-'}")),
                //       //   ],
                //       // ),
                //       // Divider(),

                //       SizedBox(
                //         width: width,
                //         child: Wrap(runAlignment: WrapAlignment.start, alignment: WrapAlignment.start, children: [
                //           ...photosBytes.map((photo) {
                //             int index = photosBytes.indexOf(photo);
                //             Position? p = index >= widget.moreDetails.tagPhotos.length
                //                 ? BasicClass.getPositionById(tag.currentPosition)
                //                 : BasicClass.getPositionById(widget.moreDetails.tagPhotos[index].positionID);
                //             return Padding(
                //               padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                //               child: GestureDetector(
                //                 onTap: () {},
                //                 child: Column(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.circular(8),
                //                       child: Container(
                //                         color: Colors.grey,
                //                         width: 44,
                //                         height: 44,
                //                         child: Image.memory(photo),
                //                       ),
                //                     ),
                //                     Text(
                //                       p?.title ?? '',
                //                       style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //         ]),
                //       ),
                //
                //       const Divider(height: 8),
                //       Expanded(
                //           flex: 3,
                //           child: SingleChildScrollView(
                //             child: Column(
                //               children: [
                //                 TagSSRListWidget(ssrs: tag.tagSsrs),
                //                 TagInboundListWidget(inLeg: tag.inboundLeg),
                //                 TagOutboundsWidget(
                //                   outLegs: tag.outboundLegs,
                //                 ),
                //                 TagPositionHistoryWidget(positions: tag.tagPositions),
                //                 TagActionHistoryWidget(actions: tag.actionsHistory),
                //                 TagLogsWidget(logs: widget.moreDetails.logs),
                //                 TagBsmsWidget(bsmList: widget.moreDetails.bsmList),
                //               ],
                //             ),
                //           )),
                //       // Divider(height: 8),
                //       // Expanded(flex: 2, child: TagActionHistoryWidget(actions: tag.actionsHistory)),
                //     ],
                //   ),
                // )),
                // Row(
                //   children: [
                //     Spacer(),
                //     const SizedBox(width: 8),
                //     MyButton(
                //       fontSize: 13,
                //       onPressed: () async {
                //         Navigator.of(context).pop();
                //       },
                //       label: "OK",
                //     ),
                //     const SizedBox(width: 12),
                //   ],
                // ),
                // const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TagSSRListWidget extends StatelessWidget {
  final List<TagSSR> ssrs;

  const TagSSRListWidget({Key? key, required this.ssrs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (ssrs.isEmpty) return const SizedBox();
    return MyExpansionTile2(
      initiallyExpanded: true,
      title: const Row(
        children: [
          Text("Specials", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(
            Icons.star_purple500,
            color: Colors.deepOrange,
          )
        ],
      ),
      children: [
        SizedBox(
          width: width,
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 4,
            children: ssrs
                .map((e) =>
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: MyColors.myGreen.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    e.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class TagInboundListWidget extends StatelessWidget {
  final TagLeg? inLeg;

  const TagInboundListWidget({Key? key, required this.inLeg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (inLeg == null) return const SizedBox();
    return MyExpansionTile2(
      title: const Row(
        children: [
          Text("Inbound", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.flight_land, color: MyColors.myGreen, size: 20),
        ],
      ),
      children: [
        Row(children: [
          AirlineLogo(inLeg!.al),
          CardField(
            title: "AL",
            value: inLeg!.al,
          ),
          const SizedBox(width: 8),
          Expanded(
              child: CardField(
                title: "FLNB",
                value: inLeg!.flnb,
              )),
          Expanded(child: CardField(title: "Date", value: inLeg!.flightDate.format_ddMMM, scale: 0.8)),
          Expanded(child: CardField(title: "City", value: inLeg!.city, scale: 0.8)),
        ]),
      ],
    );
  }
}

class TagOutboundsWidget extends StatelessWidget {
  final List<TagLeg> outLegs;

  const TagOutboundsWidget({Key? key, required this.outLegs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (outLegs.isEmpty) return const SizedBox();
    return MyExpansionTile2(
      title: const Row(
        children: [
          Text("Onward", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.flight_takeoff, color: MyColors.blueGreen, size: 20),
        ],
      ),
      children: [
        ...outLegs
            .map(
              (e) =>
              Row(children: [
                AirlineLogo(e.al),
                CardField(
                  title: "AL",
                  value: e.al,
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: CardField(
                      title: "FLNB",
                      value: e.flnb,
                    )),
                Expanded(
                    child: CardField(
                      title: "Date",
                      value: e.flightDate.format_ddMMM,
                      scale: 0.8,
                    )),
                Expanded(child: CardField(title: "City", value: e.city, scale: 0.8)),
              ]),
        )
            .toList()
      ],
    );
  }
}

class TagPositionHistoryWidget extends StatelessWidget {
  final List<TagPosition> positions;

  const TagPositionHistoryWidget({Key? key, required this.positions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (positions.isEmpty) return const SizedBox();
    return MyExpansionTile2(
      title: const Text("Positions Log", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 4, child: Text("Time")),
            Expanded(flex: 5, child: Text("User")),
            // Expanded(flex: 3, child: Text("Seq.")),
            Expanded(flex: 9, child: Text("Position/Order")),
            Expanded(flex: 4, child: Text("Details")),
          ],
        ),
        ...positions.map((e) {
          int index = positions.indexOf(e);
          TagPosition tp = e;
          DateTime? scanTimeUtc = tp.timeUtc.tryDateTimeUTC;
          // DateTime? scanTime = scanTimeUtc?.toLocal();
          DateTime? scanTime = BasicClass.getTimeFromUTC(scanTimeUtc);
          Position tagPos = BasicClass.getPositionById(tp.positionId)!;
          AirportPositionSection? sec = BasicClass.getAllAirportSections().firstWhereOrNull((element) => element.id == tp.sectionID);
          if (sec == null) return Container();
          return Container(
            color: index % 2 == 0 ? MyColors.paleGrey : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 4, child: Text("${scanTime.format_HHmmss}", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Signika"))),
                Expanded(flex: 5, child: Text("${tp.username}", overflow: TextOverflow.ellipsis)),
                // Expanded(flex: 3, child: Text("${tp.indexInPosition}")),
                Expanded(flex: 9, child: Text("${sec.label} / ${tp.indexInPosition}", style: const TextStyle(fontWeight: FontWeight.bold))),
                // Expanded(flex: 4, child: Text("${tp.positionId}")),
                Expanded(flex: 4, child: Text("${tp.containerCode}")),
              ],
            ),
          );
        }).toList()
      ],
    );
  }
}

class TagActionHistoryWidget extends StatelessWidget {
  final List<ActionHistory> actions;

  const TagActionHistoryWidget({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (actions.isEmpty) return const SizedBox();
    return MyExpansionTile2(
      title: const Text("Status Log", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        ...actions.map((e) {
          ActionHistory ah = e;
          int index = actions.indexOf(e);
          DateTime? scanTimeUtc = ah.actionTime.tryDateTimeUTC;
          DateTime? scanTime = scanTimeUtc?.toLocal();
          // TagAction tagAction = model.loginUser!.systemSettings.statusActionList.firstWhere((element) => element.id == ah.actionId);
          TagAction? tagAction = BasicClass.systemSetting.actions.firstWhereOrNull((element) => element.id == ah.actionId);
          return Container(
            color: index % 2 == 0 ? MyColors.paleGrey : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 5, child: Text("${scanTime.format_HHmmss}", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Signika"))),
                Expanded(
                    flex: 4,
                    child: Text(
                      "${ah.username}",
                      overflow: TextOverflow.ellipsis,
                    )),
                Expanded(flex: 3, child: Text("${ah.id}")),
                Expanded(flex: 8, child: Text("${tagAction?.actionTitle ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          );
        }).toList()
      ],
    );
  }
}

class DcsInfoWidget extends StatelessWidget {
  final DcsInfo? info;

  const DcsInfoWidget({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (info == null)
      return const Row(children: [
        HorizontalCardField(title: "Pax", value: "-"),
        SizedBox(width: 70),
        HorizontalCardField(title: "PNR", value: "-"),
        SizedBox(width: 70),
        HorizontalCardField(title: "P/W", value: "-"),
        SizedBox(width: 70),
        HorizontalCardField(title: "Dest", value: "-"),
        SizedBox(width: 70),
        HorizontalCardField(title: "Photo", valueWidget: Icon(Icons.camera_alt, color: Colors.blue), value: "-"),
      ]);
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
      SizedBox(width: 70),
      HorizontalCardField(title: "PNR", value: info!.pnr),
      SizedBox(width: 70),
      HorizontalCardField(title: "P/W", value: "${info!.count}/${info!.weight}"),
      SizedBox(width: 70),
      HorizontalCardField(title: "Dest", value: "${info!.dest}"),
      SizedBox(width: 70),
      HorizontalCardField(title: "Photo", valueWidget: Icon(Icons.camera_alt, color: Colors.blue), value: "-"),
    ]);
  }
}

class TagLogsWidget extends StatelessWidget {
  final List<TagLog> logs;

  const TagLogsWidget({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (logs.every((element) =>
    element.title
        .trim()
        .isEmpty)) return const SizedBox();
    return MyExpansionTile2(
      title: const Text("Logs", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(color: Colors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: logs
                .map((e) =>
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          e.title,
                          style: GoogleFonts.inconsolata(fontSize: 16),
                        )),
                  ],
                ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class TagBsmsWidget extends StatelessWidget {
  final List<Bsm> bsmList;

  const TagBsmsWidget({Key? key, required this.bsmList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    if (bsmList.isEmpty) return const SizedBox();
    return MyExpansionTile2(
      title: const Text("BSM ", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bsmList
                .map((e) =>
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Text(
                            e.bsmMessage,
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DotButton(
                            size: 40,
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: e.bsmMessage));
                            },
                            icon: Icons.copy,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            BasicClass
                                .getTimeFromUTC(e.bsmTime)
                                .format_HHmmss,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
                .toList(),
          ),
        )
      ],
    );
  }
}

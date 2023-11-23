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
    List<TahaSectionBinSection> secList = [
      TahaSectionBinSection(label: "Specials", ref: ref, position: 0),
      TahaSectionBinSection(label: "Inbound", ref: ref, position: 1),
      TahaSectionBinSection(label: "onward", ref: ref, position: 2),
      TahaSectionBinSection(label: "Position Log", ref: ref, position: 3),
      TahaSectionBinSection(label: "Status Log", ref: ref, position: 4),
      TahaSectionBinSection(label: "BSM", ref: ref, position: 5),
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
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                SizedBox(height: 20),
                DcsInfoWidget(info: tag.dcsInfo),
                SizedBox(height: 20),
                const Divider(thickness: 2, height: 1),
                SizedBox(height: 20),
                Flexible(
                  child: ExpandableListView(
                    builder: SliverExpandableChildDelegate<int, TahaSectionBinSection>(
                        sectionList: secList,
                        headerBuilder: (context, sectionIndex, index) {
                          return SectionTileWidget2(
                            secTag: secList[sectionIndex],
                            iconData: Icons.star_border_rounded,
                            tag: tag,
                            f: f,
                          );
                        },
                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                          return Text("test");
                        }),
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

class DcsInfoWidget extends StatelessWidget {
  final DcsInfo? info;

  const DcsInfoWidget({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
      HorizontalCardField(title: "Photo", valueWidget: Icon(Icons.add_a_photo_outlined, color: Colors.blue), value: "-"),
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
  final TahaSectionBinSection? secTag;
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
                SizedBox(height: 25, child: tag.getTahaWidget("Inbound", Colors.green)),
                const SizedBox(width: 12),
                SizedBox(height: 25, child: tag.getTahaWidget("Inbound", Colors.green)),
              ],
            ),
          )
        : secTag!.position == 2
            ? SizedBox(
                height: 60,
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(iconData),
                  ),
                  Text(secTag!.label, style: const TextStyle(color: MyColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: AirlineLogo(
                      f.al,
                      size: 50,
                    ),
                  ),
                  SizedBox(width: 70),
                  HorizontalCardField(title: "AL", value: "FZ"),
                  SizedBox(width: 70),
                  HorizontalCardField(title: "FLNB", value: "047"),
                  SizedBox(width: 70),
                  HorizontalCardField(title: "Date", value: "23 November"),
                  SizedBox(width: 70),
                  HorizontalCardField(title: "City", value: "MCT"),
                ]),
              )
            : InkWell(
                onTap: () {
                  // if (position == secTag?.position) {
                  secTag?.setSectionExpanded(!secTag!.isSectionExpanded());
                  // }
                },
                child: Container(
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                .map((e) => Container(
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              (e) => Row(children: [
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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

class TagLogsWidget extends StatelessWidget {
  final List<TagLog> logs;

  const TagLogsWidget({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (logs.every((element) => element.title.trim().isEmpty)) return const SizedBox();
    return MyExpansionTile2(
      title: const Text("Logs", style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(color: Colors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: logs
                .map((e) => Row(
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                .map((e) => Container(
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
                                BasicClass.getTimeFromUTC(e.bsmTime).format_HHmmss,
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

class TahaSectionBinSection extends ExpandableListSection<int> {
  final WidgetRef ref;
  String label;
  final int position;

  TahaSectionBinSection({
    required this.ref,
    required this.label,
    required this.position,
  });

  @override
  List<int>? getItems() {
    return [0, 1, 2];
  }

  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedTagDetailsDialog);
    return !expandeds.contains(position);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedTagDetailsDialog.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [position];
    } else {
      expandeds.state = expandeds.state.where((element) => element != position).toList();
    }
  }

  List<int> get items {
    return getItems() ?? [];
  }
}

import 'dart:convert';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DetailsChart.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/data_bases_keys.dart';
import '../../core/data_base/web_data_base.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MySegment.dart';
import '../../widgets/MyTextField.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';
import 'widgets/data_tables/checkin_table_builder.dart';
import 'widgets/data_tables/load_table_builder.dart';
import 'widgets/data_tables/sort_table_builder.dart';

class FlightDetailsView extends ConsumerWidget {
  final int flightID;

  const FlightDetailsView({super.key, required this.flightID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flightDetailsProvider);
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            FlightDetailsPanel(),
            FlightDetailsWidget(),
          ],
        ));
  }
}

class FlightDetailsPanel extends ConsumerWidget {
  const FlightDetailsPanel({Key? key}) : super(key: key);
  static FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();
  static TextEditingController searchC = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flightDetailsProvider);
    ref.watch(tagSearchProvider);
    final selectedFlightP = ref.watch(selectedFlightProvider);
    List<Position> pos = BasicClass.systemSetting.positions.where((element) => (selectedFlightP?.positions ?? []).map((e) => e.id).contains(element.id)).toList();
    Flight f = selectedFlightP ?? Flight.empty();
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // DotButton(
          //   size: 35,
          //   onPressed: () {
          //     // myFlightsController.goAddFlight();
          //   },
          //   icon: Icons.add,
          //   color: Colors.blueAccent,
          // ),
          // const SizedBox(width: 12),
          Expanded(
              flex: 1,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here ...",
                controller: searchC,
                showClearButton: state.showClearButton,
                onChanged: (v) {
                  state.showClearButton = searchC.text.isNotEmpty;
                  final s = ref.read(tagSearchProvider.notifier);
                  s.state = v;
                },
              )),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MySegment<Position>(
                height: 35,
                itemToString: (e) => e.title,
                items: pos,
                onChange: (Position v) {
                  ref.read(selectedPosInDetails.notifier).state = v;
                  SessionStorage().setString(SsKeys.selectedPosInDetails, jsonEncode(v.toJson()));
                },
                value: ref.watch(selectedPosInDetails),
              )),
          const Expanded(flex: 1, child: SizedBox(width: 12)),
          const SizedBox(width: 12),
          FlightBanner(flight: f),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.refresh,
            onPressed: () async {
              // final sfp = ref.read(selectedFlightProvider);
              // final fdP = ref.read(detailsProvider);
              ref.refresh(refreshDetailsProvider);
              // FlightsController flightsController = getIt<FlightsController>();
              // flightsController.flightList(ref.read(flightDateProvider));
            },
          ),
        ],
      ),
    );
  }
}

class FlightDetailsWidget extends ConsumerWidget {
  const FlightDetailsWidget({Key? key}) : super(key: key);
  static FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    final fdP = ref.watch(detailsProvider.notifier);
    final rfdP = ref.watch(refreshDetailsProvider);
    final posListP = ref.watch(selectedFlightProvider);
    List<Position> posList = BasicClass.systemSetting.positions.where((pos) => (posListP?.positions ?? []).map((e) => e.id).contains(pos.id)).toList();
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: rfdP.when(
          skipLoadingOnRefresh: false,
          data: (d0) {
            FlightDetails? d = fdP.state;
            if (d == null) return const Text("No Data Found");
            return Row(
              children: [
                Expanded(flex: 42, child: DetailsWidget(details: d, posList: posList)),
                Expanded(
                  flex: 10,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(border: Border(left: BorderSide(color: MyColors.lineColor))),
                      child: Column(
                        children: [
                          DetailsChart(details: d, posList: posList),
                          DetailsLineChart(details: d, posList: posList),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (e, __) => Text("$e"),
          loading: () => Spinners.spinner1,
        ),
      ),
    );
  }
}

class DetailsWidget extends ConsumerStatefulWidget {
  final List<Position> posList;
  final FlightDetails details;

  const DetailsWidget({Key? key, required this.details, required this.posList}) : super(key: key);

  @override
  ConsumerState<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends ConsumerState<DetailsWidget> with SingleTickerProviderStateMixin {
  static FlightDetailsController controller = getIt<FlightDetailsController>();
  late TabController tabController;
  late List<Position> posList;

  @override
  void initState() {
    // posList = BasicClass.systemSetting.positions.where((pos) => widget.details.tagList.any((element) => element.currentPosition == pos.id)).toList();
    posList = widget.posList;
    tabController = TabController(
      length: posList.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Position selectedPos = ref.watch(selectedPosInDetails)!;
    String searched = ref.watch(tagSearchProvider);
    List<FlightTag> filteredTag = widget.details.tagList.where((e) => e.validateSearch(searched, selectedPos)).toList();
    List<TagContainer> cons = widget.details.containerList.where((e) => e.positionID == selectedPos.id /* && filteredTag.any((f) => f.containerID == e.id) */).toList();
    List<TagContainer> bulks = widget.posList.map((e) => TagContainer.bulk(e.id)).toList(); /*.where((e) => filteredTag.any((f) => f.containerID == e.id))*/
    cons = cons + bulks.where((b) => (b.positionID == selectedPos.id)).toList(); /* && element.items.isNotEmpty */
    List<Bin> bins = widget.details.binList.toList(); /*.where((e) => filteredTag.any((c) => c.binID == e.id))*/
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: dataTableFlexes[0],
                        child: DataCellWidget(
                          child: Row(children: [
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text('#', style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 48),
                            const Spacer(),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Tag Number', style: TextStyles.tagListHeader)),
                          ]),
                        ),
                      ),
                      Expanded(
                        flex: dataTableFlexes[1],
                        child: const DataCellWidget(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Sec.', style: TextStyles.tagListHeader))),
                      ),
                      Expanded(
                        flex: dataTableFlexes[2],
                        child: const DataCellWidget(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Pax Name', style: TextStyles.tagListHeader))),
                      ),
                      Expanded(
                        flex: dataTableFlexes[3],
                        child: const DataCellWidget(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Time', style: TextStyles.tagListHeader))),
                      ),
                      Expanded(
                        flex: dataTableFlexes[4],
                        child: const DataCellWidget(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('Agent', style: TextStyles.tagListHeader))),
                      ),
                      Expanded(
                        flex: dataTableFlexes[5],
                        child: const DataCellWidget(child: Padding(padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8), child: Text('Weight', style: TextStyles.tagListHeader))),
                      ),
                    ],
                  ),
                ),
                selectedPos.id == 3 || selectedPos.id == 4
                    ? LoadTableBuilder(fd: widget.details, bins: bins, cons: cons, tags: filteredTag)
                    : selectedPos.id == 2 || selectedPos.id == 5 || selectedPos.id == 6
                        ? SortTableBuilder(fd: widget.details, cons: cons, tags: filteredTag)
                        : CheckinTableBuilder(fd: widget.details, tags: filteredTag),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SectionTileWidget extends StatelessWidget {
  const SectionTileWidget({super.key, required this.label, required this.tagCount});

  final String label;
  final int tagCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.sectionGrey,
      height: 60,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: MyColors.white3, fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            height: 25,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.white3.withOpacity(0.7))),
            child: Text("Tags: $tagCount", style: TextStyle(fontSize: 12, color: MyColors.white3.withOpacity(0.7))),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class ContainerTileWidget extends StatelessWidget {
  final FlightDetailsController controller = getIt<FlightDetailsController>();
  final TagContainer con;
  final List<FlightTag> items;
  final bool isFirstSec;
  final bool isLast;
  final bool binLines;
  final int tagCount;

  ContainerTileWidget({
    Key? key,
    required this.con,
    required this.items,
    required this.isFirstSec,
    required this.isLast,
    required this.binLines,
    required this.tagCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          binLines ? Container(width: 1.5, height: isLast ? 20 : 40, color: MyColors.binGrey) : const SizedBox(),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: 45, height: 1, color: binLines ? MyColors.binGrey : Colors.transparent),
                      con.getImg,
                      if (con.isClosed)
                        Container(
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(3)),
                          width: 46,
                          height: 46,
                          alignment: Alignment.bottomCenter,
                          child: const Text("Closed!", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  const Icon(Icons.circle, color: MyColors.binGrey, size: 8),
                  const SizedBox(width: 8),
                  Text("${con.title} ${con.code}"),
                  const SizedBox(width: 8),
                  con.allowedTagTypesWidgetMini2(items),
                  const SizedBox(width: 16),
                  if (!(con.isActive ?? true))
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: MyColors.binGrey),
                      child: const Text("Inactive", style: TextStyle(color: Colors.white)),
                    ),
                  const Spacer(),
                  if (con.spotID != null) Text(con.getSpot?.label ?? "", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                  MyButton(
                    label: "PDF",
                    height: 25,
                    onPressed: () async => await controller.getContainerPDF(con),
                    child: const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.picture_as_pdf_outlined, size: 16),
                        SizedBox(width: 5),
                        Text("PDF", style: TextStyle(fontSize: 12)),
                        SizedBox(width: 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Container(
                  //   height: 25,
                  //   width: 100,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.black3.withOpacity(0.5))),
                  //   child: Text(
                  //     "Tags: $tagCount",
                  //     style: const TextStyle(fontSize: 12),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BinTileWidget extends StatelessWidget {
  final Bin bin;
  final List<TagContainer> items;
  final bool isFirstSec;
  final int tagCount;

  const BinTileWidget({Key? key, required this.bin, required this.items, required this.isFirstSec, required this.tagCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          // IconButton(
          //     onPressed: () {
          //       sec.setSectionExpanded(!sec.isSectionExpanded());
          //     },
          //     icon: Icon(
          //       sec.isSectionExpanded() ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          //       color: Colors.white,
          //     )),
          const SizedBox(width: 20),
          Text(
            "Bin ${bin.bin} ${items.length}",
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (bin.containerType != 1)
            Container(
              height: 25,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.white3.withOpacity(0.5))),
              child: Text(
                "Containers: ${items.length}",
                style: const TextStyle(fontSize: 12, color: MyColors.white3),
              ),
            ),
          const SizedBox(width: 8),
          Container(
            height: 25,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.white3.withOpacity(0.5))),
            child: Text(
              "Tags: $tagCount",
              style: const TextStyle(fontSize: 12, color: MyColors.white3),
            ),
          ),
        ],
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  final FlightTag tag;
  final FlightDetails? fd;
  final int index;
  final int total;
  final bool isLast;
  final bool hasBinLine;
  final bool hasTagLine;
  final bool inDetails;
  final bool alterColor;

  const TagWidget(
      {Key? key,
      required this.tag,
      required this.index,
      this.isLast = false,
      required this.hasBinLine,
      this.hasTagLine = true,
      required this.total,
      required this.fd,
      this.inDetails = false,
      this.alterColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle tagNumStyle = TextStyle(
        fontFamily: "Signika",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: tag.isForced
            ? MyColors.havaPrime
            : tag.currentStatus > 0
                ? tag.getStatus.getColor
                : MyColors.black1);
    return Container(
      decoration: BoxDecoration(color: alterColor ? (index.isEven ? MyColors.evenRow3 : MyColors.oddRow3) : (!index.isEven ? MyColors.evenRow : MyColors.oddRow)),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: dataTableFlexes[0],
            child: DataCellWidget(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),

                  // Container(
                  //     width: 40,
                  //     height: 40,
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       '${total - index}',
                  //       style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold),
                  //     )),
                  // const SizedBox(width: 8),
                  // (hasBinLine && !inDetails)
                  //     ? Container(width: 2, height: 40, color: MyColors.binGrey)
                  //     : const SizedBox(
                  //         width: 10,
                  //       ),
                  // (hasTagLine && !inDetails)
                  //     ? Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                  //           Container(
                  //             width: 10,
                  //             height: 2,
                  //             color: MyColors.containerGreen,
                  //             margin: const EdgeInsets.only(top: 19),
                  //           ),
                  //           const Padding(
                  //             padding: EdgeInsets.only(top: 16.0),
                  //             child: Icon(Icons.circle, color: MyColors.containerGreen, size: 8),
                  //           ),
                  //         ],
                  //       )
                  //     : const SizedBox(width: 10),
                  // IndexedStack(
                  //   index: tag.inboundLeg == null ? 0 : 1,
                  //   children: [
                  //     const SizedBox(),
                  //     Container(
                  //       height: 40,
                  //       padding: const EdgeInsets.only(left: 2),
                  //       child: const Icon(Icons.flight_land, color: MyColors.green, size: 20),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tag.getStatusWidget(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      tag.numString,
                      style: tagNumStyle,
                    ),
                  ),

                  SizedBox(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [tag.getTypeWidget],
                    ),
                  ),
                  const SizedBox(width: 4),
                  IndexedStack(
                    index: tag.inboundLeg == null ? 0 : 1,
                    children: [
                      const SizedBox(),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 2),
                        child: const Icon(Icons.flight_land, color: MyColors.green, size: 20),
                      )
                    ],
                  ),
                  IndexedStack(
                    index: tag.outboundLegs.isEmpty ? 0 : 1,
                    children: [
                      const SizedBox(),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 2),
                        child: const Icon(Icons.flight_takeoff, color: MyColors.blueGreen, size: 20),
                      )
                    ],
                  ),
                  const Spacer(),
                  inDetails
                      ? const SizedBox()
                      : SizedBox(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DotButton(
                                icon: Icons.info,
                                size: 20,
                                onPressed: () async {
                                  FlightDetailsController fd = getIt<FlightDetailsController>();
                                  await fd.flightGetTagMoreDetails(tag.flightScheduleId, tag);
                                },
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(width: 8),
                  // const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          Expanded(
            flex: dataTableFlexes[1],
            child: DataCellWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(tag.secString),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        fd == null
                            ? const SizedBox()
                            : Text(
                                "(${fd!.tagList.where((element) => element.dcsInfo != null && element.dcsInfo?.securityCode == tag.dcsInfo?.securityCode).length})",
                              ),
                        const SizedBox(width: 8),
                        Icon(tag.posIcon, color: tag.posColor, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: dataTableFlexes[2],
            child: DataCellWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(tag.dcsInfo?.paxName ?? '-')),
                    IndexedStack(
                      index: tag.tagSsrs.isEmpty
                          ? 0
                          : tag.tagSsrs.length == 1
                              ? 1
                              : 1,
                      children: [
                        const SizedBox(),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                          decoration: BoxDecoration(color: MyColors.green.withOpacity(0.4), borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            tag.tagSsrs.isEmpty ? "" : tag.tagSsrs.map((e) => e.name).join(", "),
                            style: const TextStyle(fontSize: 8),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Icon(Icons.star_purple500, color: Colors.deepOrange, size: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: dataTableFlexes[3],
            child: DataCellWidget(
              child: Text(tag.tagPositions.first.getTime()),
            ),
          ),
          Expanded(
            flex: dataTableFlexes[4],
            child: DataCellWidget(
              child: Text(tag.tagPositions.first.username),
            ),
          ),
          Expanded(
            flex: dataTableFlexes[5],
            child: DataCellWidget(
              child: tag.weight,
            ),
          ),
        ],
      ),
    );
  }
}

class DataCellWidget extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const DataCellWidget({Key? key, required this.child, this.alignment = Alignment.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: MyColors.lineColor))),
      child: child,
    );
  }
}

const List<int> dataTableFlexes = [35, 10, 25, 10, 10, 7];

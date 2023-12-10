import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DetailsChart.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyExpansionTile2.dart';
import '../../widgets/MySegment.dart';
import '../../widgets/MyTextField.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';
import 'widgets/expandable_list_sections/airport_section.dart';

class FlightDetailsView extends StatefulWidget {
  final int flightID;

  const FlightDetailsView({super.key, required this.flightID});

  @override
  State<FlightDetailsView> createState() => _FlightDetailsViewState();
}

class _FlightDetailsViewState extends State<FlightDetailsView> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => getIt<FlightDetailsController>().flightGetDetails(widget.flightID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
  static FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();
  static TextEditingController searchC = TextEditingController();

  const FlightDetailsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    List<Position> pos = BasicClass.systemSetting.positions
        .where((element) => ref.watch(selectedFlightProvider)!.positions.map((e) => e.id).contains(element.id))
        .toList();
    Flight f = ref.watch(selectedFlightProvider)!;
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
                placeholder: "Search Here...",
                controller: searchC,
                showClearButton: true,
                onChanged: (v) {
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
    final state = ref.watch(flightDetailsProvider);
    final fdP = ref.watch(detailsProvider.notifier);
    final rfdP = ref.watch(refreshDetailsProvider);
    final posListP = ref.watch(selectedFlightProvider);
    List<Position> posList = BasicClass.systemSetting.positions
        .where((pos) => posListP!.positions.map((e) => e.id).contains(pos.id))
        .toList();
    return Expanded(
      child: Container(
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
    List<TagContainer> cons = widget.details.containerList
        .where((e) => e.positionID == selectedPos.id /* && filteredTag.any((f) => f.containerID == e.id) */)
        .toList();
    List<TagContainer> bulks = widget.posList
        .map((e) => TagContainer.bulk(e.id)) /*.where((e) => filteredTag.any((f) => f.containerID == e.id))*/
        .toList();
    cons = cons + bulks.where((b) => (b.positionID == selectedPos.id) /* && element.items.isNotEmpty */).toList();
    List<Bin> bins = widget.details.binList /*.where((e) => filteredTag.any((c) => c.binID == e.id))*/ .toList();
    //assigning sections
    final List<AirportPositionSection> positionSections = BasicClass.getAllAirportSections();
    List<AirportPositionSection> filteredSections = positionSections
        .where((element) =>
            element.position == selectedPos.id &&
            element.subs.isEmpty &&
            AirportSectionTagSection(airportPositionSection: element, tags: filteredTag, ref: ref).isShow)
        .toList();

    final List<AirportSectionTagSection> sectionSectionsTag = filteredSections
        .map((e) => AirportSectionTagSection(airportPositionSection: e, tags: filteredTag, ref: ref))
        .where((e) => e.isShow)
        .toList();
    final List<AirportSectionContainerSection> sectionSectionsCon = filteredSections
        .map((e) => AirportSectionContainerSection(airportPositionSection: e, cons: cons, ref: ref))
        .where((e) => e.isShow)
        .toList();
    final List<AirportSectionBinSection> sectionSectionsBin = filteredSections
        .map((e) => AirportSectionBinSection(airportPositionSection: e, bins: bins, ref: ref))
        .where((e) => e.isShow)
        .toList();
    return Column(
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
                      child: Text('#',
                          style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 48),
                    const Spacer(),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Tag Number', style: TextStyles.tagListHeader)),
                  ]),
                ),
              ),
              Expanded(
                flex: dataTableFlexes[1],
                child: const DataCellWidget(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Sec.', style: TextStyles.tagListHeader))),
              ),
              Expanded(
                flex: dataTableFlexes[2],
                child: const DataCellWidget(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Pax Name', style: TextStyles.tagListHeader))),
              ),
              Expanded(
                flex: dataTableFlexes[3],
                child: const DataCellWidget(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Time', style: TextStyles.tagListHeader))),
              ),
              Expanded(
                flex: dataTableFlexes[4],
                child: const DataCellWidget(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('Agent', style: TextStyles.tagListHeader))),
              ),
              Expanded(
                flex: dataTableFlexes[5],
                child: const DataCellWidget(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                        child: Text('Weight', style: TextStyles.tagListHeader))),
              ),
            ],
          ),
        ),
        selectedPos.binRequired
            ? Flexible(
                child: ExpandableListView(
                  builder: SliverExpandableChildDelegate<Bin, AirportSectionBinSection>(
                      sectionList: sectionSectionsBin,
                      headerBuilder: (context, sectionIndex, index) {
                        return SectionTileWidget(secTag: null, secCon: null, secBin: sectionSectionsBin[sectionIndex]);
                      },
                      itemBuilder: (context, sectionIndex, itemIndex, index) {
                        Bin bin = sectionSectionsBin[sectionIndex].items[itemIndex];
                        List<TagContainer> thisBinCons = controller.getBinContainers(bin, cons, widget.details, false);
                        List<FlightTag> tags = filteredTag.where((e) => e.tagPositions.first.binID == bin.id).toList();
                        return MyExpansionTile2(
                          title: BinTileWidget(tagCount: tags.length, isFirstSec: false, bin: bin, items: thisBinCons),
                          showIcon: false,
                          showLeadingIcon: true,
                          iconColor: MyColors.white3,
                          collapsedIconColor: MyColors.white3,
                          childrenPadding: EdgeInsets.zero,
                          backgroundColor: index.isEven ? MyColors.binGrey : MyColors.binGrey2,
                          children: thisBinCons.map((e) {
                            TagContainer con = e;
                            bool isLastCon = (e == thisBinCons.last);
                            List<FlightTag> thisConTags = controller.getContainerTags(con, tags);
                            return con.type != "ULD"
                                ? Column(
                                    children: thisConTags
                                        .map((e) => TagWidget(
                                              tag: e,
                                              fd: widget.details,
                                              total: thisConTags.length,
                                              index: thisConTags.indexOf(e),
                                              hasBinLine: !isLastCon,
                                              isLast: thisConTags.last == e,
                                            ))
                                        .toList())
                                : MyExpansionTile2(
                                    title: ContainerTileWidget(
                                      isLast: isLastCon,
                                      binLines: true,
                                      con: con,
                                      items: thisConTags,
                                      isFirstSec: false,
                                      tagCount: thisConTags.length,
                                    ),
                                    showIcon: false,
                                    showLeadingIcon: true,
                                    iconColor: MyColors.white3,
                                    collapsedIconColor: MyColors.white3,
                                    childrenPadding: EdgeInsets.zero,
                                    backgroundColor: index.isEven ? MyColors.containerGreen : MyColors.containerGreen2,
                                    children: thisConTags
                                        .map((e) => TagWidget(
                                              tag: e,
                                              fd: widget.details,
                                              total: thisConTags.length,
                                              index: thisConTags.indexOf(e),
                                              hasBinLine: !isLastCon,
                                              isLast: thisConTags.last == e,
                                            ))
                                        .toList(),
                                  );
                          }).toList(),
                        );
                      }),
                ),
              )
            : selectedPos.containerRequired
                ? Flexible(
                    child: ExpandableListView(
                      builder: SliverExpandableChildDelegate<TagContainer, AirportSectionContainerSection>(
                          sectionList: sectionSectionsCon,
                          headerBuilder: (context, sectionIndex, index) {
                            return SectionTileWidget(
                                secTag: null, secCon: sectionSectionsCon[sectionIndex], secBin: null);
                          },
                          itemBuilder: (context, sectionIndex, itemIndex, index) {
                            TagContainer con = sectionSectionsCon[sectionIndex].items[itemIndex];
                            List<FlightTag> thisConTags = filteredTag
                                .where((element) => (element.getContainerID == con.id ||
                                    (element.getContainerID == null &&
                                        con.isCart)) /*&& element.tagPositions.first.binID == bins[sectionIndex].bin.id*/)
                                .toList();
                            return MyExpansionTile2(
                              title: ContainerTileWidget(
                                isFirstSec: false,
                                binLines: false,
                                con: con,
                                items: thisConTags,
                                isLast: false,
                                tagCount: thisConTags.length,
                              ),
                              showLeadingIcon: true,
                              showIcon: false,
                              childrenPadding: EdgeInsets.zero,
                              iconColor: MyColors.brownGrey5,
                              collapsedIconColor: MyColors.brownGrey5,
                              backgroundColor: index.isEven ? MyColors.containerGreen : MyColors.containerGreen2,
                              children: thisConTags
                                  .map((e) => TagWidget(
                                      tag: e,
                                      fd: widget.details,
                                      total: thisConTags.length,
                                      index: thisConTags.indexOf(e),
                                      hasBinLine: false,
                                      isLast: thisConTags.last == e))
                                  .toList(),
                            );
                          }),
                    ),
                  )
                : Flexible(
                    child: ExpandableListView(
                      builder: SliverExpandableChildDelegate<FlightTag, AirportSectionTagSection>(
                          sectionList: sectionSectionsTag,
                          headerBuilder: (context, sectionIndex, index) {
                            return SectionTileWidget(
                                secTag: sectionSectionsTag[sectionIndex], secCon: null, secBin: null);
                          },
                          itemBuilder: (context, sectionIndex, itemIndex, index) {
                            FlightTag tag = sectionSectionsTag[sectionIndex].items[itemIndex];
                            return TagWidget(
                              tag: tag,
                              index: itemIndex,
                              fd: widget.details,
                              total: filteredTag.length,
                              hasBinLine: false,
                              hasTagLine: false,
                            );
                          }),
                    ),
                  ),
      ],
    );
  }
}

class SectionTileWidget extends StatelessWidget {
  const SectionTileWidget({super.key, required this.secTag, required this.secCon, required this.secBin});

  final AirportSectionTagSection? secTag;
  final AirportSectionContainerSection? secCon;
  final AirportSectionBinSection? secBin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => secBin != null
          ? secBin!.setSectionExpanded(!secBin!.isSectionExpanded())
          : secCon != null
              ? secCon!.setSectionExpanded(!secCon!.isSectionExpanded())
              : secTag!.setSectionExpanded(!secTag!.isSectionExpanded()),
      child: Container(
        color: MyColors.sectionGrey,
        height: 60,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            IconButton(
                onPressed: () => secBin != null
                    ? secBin!.setSectionExpanded(!secBin!.isSectionExpanded())
                    : secCon != null
                        ? secCon!.setSectionExpanded(!secCon!.isSectionExpanded())
                        : secTag!.setSectionExpanded(!secTag!.isSectionExpanded()),
                icon: Icon(
                  (secBin != null
                          ? secBin!.isSectionExpanded()
                          : secCon != null
                              ? secCon!.isSectionExpanded()
                              : secTag!.isSectionExpanded())
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                )),
            Text(
                secBin != null
                    ? secBin!.airportPositionSection.label
                    : secCon != null
                        ? secCon!.airportPositionSection.label
                        : secTag!.airportPositionSection.label,
                style: const TextStyle(color: MyColors.white3, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
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
                      con.getImg
                    ],
                  ),
                  const Icon(Icons.circle, color: MyColors.binGrey, size: 8),
                  const SizedBox(width: 8),
                  Text("${con.title} ${con.code}"),
                  const SizedBox(width: 8),
                  con.allowedTagTypesWidgetMini,
                  const Spacer(),
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
                  Container(
                    height: 25,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: MyColors.black3.withOpacity(0.5))),
                    child: Text(
                      "Tags: $tagCount",
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
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

  const BinTileWidget(
      {Key? key, required this.bin, required this.items, required this.isFirstSec, required this.tagCount})
      : super(key: key);

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
          if (!items.any((e) => e.type == "ULD"))
            Container(
              height: 25,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.white3.withOpacity(0.5))),
              child: Text(
                "Tags: $tagCount",
                style: const TextStyle(fontSize: 12, color: MyColors.white3),
              ),
            ),
          const SizedBox(width: 8),
          Container(
            height: 25,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.white3.withOpacity(0.5))),
            child: Text(
              "Containers: ${items.length}",
              style: const TextStyle(fontSize: 12, color: MyColors.white3),
            ),
          )
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

  const TagWidget(
      {Key? key,
      required this.tag,
      required this.index,
      this.isLast = false,
      required this.hasBinLine,
      this.hasTagLine = true,
      required this.total,
      required this.fd,
      this.inDetails = false})
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
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
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
                  SizedBox(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tag.getStatusWidget,
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
                  const SizedBox(width: 12),
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
                          decoration: BoxDecoration(
                              color: MyColors.green.withOpacity(0.4), borderRadius: BorderRadius.circular(2)),
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

import 'dart:math';

import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DetailsChart.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MySeparator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyExpansionTile.dart';
import '../../widgets/MySegment.dart';
import '../../widgets/MyTextField.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';

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
  static TextEditingController searchC = TextEditingController();

  const FlightDetailsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    List<Position> pos = BasicClass.systemSetting.positions.where((element) => ref.watch(selectedFlightProvider)!.positions.map((e) => e.id).contains(element.id)).toList();
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
          const Expanded(flex: 2, child: SizedBox(width: 12)),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.refresh,
            onPressed: () {
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
    final fdP = ref.watch(detailsProvider);
    final posListP = ref.watch(selectedFlightProvider);
    List<Position> posList = BasicClass.systemSetting.positions.where((pos) => posListP!.positions.map((e) => e.id).contains(pos.id)).toList();
    return Expanded(
      child: Container(
        child: fdP.when(
          data: (d) => d == null
              ? const Text("No Data Found")
              : Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: DetailsWidget(
                        details: d,
                        posList: posList,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(border: Border(left: BorderSide(color: MyColors.lineColor))),
                        child: Column(
                          children: [
                            DetailsChart(
                              details: d,
                              posList: posList,
                            ),
                            DetailsLineChart(
                              details: d,
                              posList: posList,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
  late TabController controller;
  late List<Position> posList;

  @override
  void initState() {
    // posList = BasicClass.systemSetting.positions.where((pos) => widget.details.tagList.any((element) => element.currentPosition == pos.id)).toList();
    posList = widget.posList;
    controller = TabController(
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

    List<ContainerSection> cons = widget.details.containerList.where((element) => selectedPos == null || element.positionID == selectedPos.id).map((e) => ContainerSection(con: e, allTags: filteredTag, ref: ref)).toList();

    List<ContainerSection> bulks = widget.posList.map((e) => ContainerSection(con: TagContainer.bulk(e.id), allTags: filteredTag, ref: ref)).toList();
    // ContainerSection bulkSec = ContainerSection(con: TagContainer.bulk(selectedPos?.id), allTags: widget.details.tagList, ref: ref);
    cons = cons + bulks.where((element) => (element.con.positionID == selectedPos.id) && element.items.isNotEmpty).toList();
    List<TagContainer> filteredCons = widget.details.containerList.where((element) => filteredTag.any((tag) => tag.getContainerID == element.id)).toList();
    // if (selectedPos.binRequired) {
    //   List<FlightTag> inBinNoCon = filteredTag.where((element) => element.currentPosition == selectedPos.id && element.getContainerID == null).toList();
    //   if(inBinNoCon.isNotEmpty) {
    //     TagContainer fakeCon = TagContainer.bulk(selectedPos.id);
    //     filteredCons.add(fakeCon);
    //   }
    // }
    List<BinSection> bins = widget.details.binList.map((b) => BinSection(bin: b, allCons: filteredCons, ref: ref, fd: widget.details)).toList();

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: DataCellWidget(
                      child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '#',
                            style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(width: 48),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          'Tag Number',
                          style: TextStyles.tagListHeader,
                        ),
                      ),
                    ],
                  ))),
              const Expanded(
                  flex: 1,
                  child: DataCellWidget(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Sec.', style: TextStyles.tagListHeader),
                  ))),
              const Expanded(
                  flex: 3,
                  child: DataCellWidget(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Pax Name', style: TextStyles.tagListHeader),
                  ))),
              const Expanded(
                  flex: 1,
                  child: DataCellWidget(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Time', style: TextStyles.tagListHeader),
                  ))),
              const Expanded(
                  flex: 2,
                  child: DataCellWidget(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Agent', style: TextStyles.tagListHeader),
                  ))),
              const Expanded(
                  flex: 1,
                  child: DataCellWidget(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Order', style: TextStyles.tagListHeader),
                  ))),
            ],
          ),
        ),
        selectedPos.binRequired
            ? Flexible(
                child: ExpandableListView(
                  builder: SliverExpandableChildDelegate<TagContainer, BinSection>(
                      sectionList: bins,
                      headerBuilder: (context, sectionIndex, index) {
                        Bin bin = bins[sectionIndex].bin;
                        // int count = List.generate(sectionIndex, (index) => cons[index].items.length).sum as int;
                        // bool isFirstSec = index == (count-sectionIndex);
                        return BinTileWidget(
                          isFirstSec: false,
                          bin: bin,
                          sec: bins[sectionIndex],
                        );
                      },
                      itemBuilder: (context, sectionIndex, itemIndex, index) {
                        TagContainer con = bins[sectionIndex].items[itemIndex];
                        bool isLastCon = bins[sectionIndex].items.length == itemIndex + 1;
                        List<FlightTag> thisConTags =
                            filteredTag.where((element) => (element.getContainerID == con.id || (element.getContainerID == null && con.isBulk)) && element.tagPositions.first.binID == bins[sectionIndex].bin.id).toList();

                        // if(thisConTags.isEmpty) return const SizedBox();
                        return MyExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          headerTileColor: MyColors.containerGreen,
                          title: ContainerTileWidget(
                            isLast: isLastCon,
                            binLines: true,
                            con: con,
                            sec: ContainerSection(con: con, allTags: filteredTag, ref: ref),
                            isFirstSec: false,
                            tagCount: thisConTags.length,
                          ),
                          children: thisConTags
                              .map((e) => TagWidget(
                                    tag: e,
                                    index: thisConTags.indexOf(e),
                                    hasBinLine: !isLastCon,
                                    isLast: thisConTags.last == e,
                                  ))
                              .toList(),
                        );
                      }),
                ),
              )
            : selectedPos.containerRequired
                ? Flexible(
                    child: ExpandableListView(
                      builder: SliverExpandableChildDelegate<FlightTag, ContainerSection>(
                          sectionList: cons,
                          headerBuilder: (context, sectionIndex, index) {
                            TagContainer con = cons[sectionIndex].con;
                            return ContainerTileWidget(
                              isFirstSec: false,
                              binLines: false,
                              con: con,
                              sec: cons[sectionIndex],
                              isLast: false,
                              tagCount: cons[sectionIndex].items.length,
                            );
                          },
                          itemBuilder: (context, sectionIndex, itemIndex, index) {
                            FlightTag tag = cons[sectionIndex].items[itemIndex];
                            bool isLastTag = cons[sectionIndex].items.length == itemIndex + 1;
                            return TagWidget(
                              tag: tag,
                              index: index,
                              hasBinLine: false,
                              isLast: isLastTag,
                            );
                          }),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(itemCount: filteredTag.length, itemBuilder: (c, i) => TagWidget(tag: filteredTag[i], index: i, hasBinLine: false)),
                  ),
      ],
    );
  }
}

class ContainerTileWidget extends StatelessWidget {
  final ContainerSection sec;
  final TagContainer con;
  final bool isFirstSec;
  final bool isLast;
  final bool binLines;
  final int tagCount;

  const ContainerTileWidget({
    Key? key,
    required this.con,
    required this.sec,
    required this.isFirstSec,
    required this.isLast,
    required this.binLines,
    required this.tagCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AbsorbPointer(
      absorbing: binLines,
      child: GestureDetector(
        onTap: () {
          sec.setSectionExpanded(!sec.isSectionExpanded());
        },
        child: Container(
          decoration: const BoxDecoration(
            color: MyColors.containerGreen,
          ),
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              binLines ? Container(width: 1.5, height: isLast ? 20 : 40, color: MyColors.binGreen) : SizedBox(),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [Container(width: 45, height: 1, color: binLines ? MyColors.binGreen : Colors.transparent), con.getImg],
                      ),
                      const Icon(Icons.circle, color: MyColors.binGreen, size: 8),
                      const SizedBox(width: 8),
                      Text("${con.title} ${con.code}"),
                      const Spacer(),
                      Container(
                        height: 25,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.black3.withOpacity(0.5))),
                        child: Text(
                          "Tags: ${tagCount}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BinTileWidget extends StatelessWidget {
  final BinSection sec;
  final Bin bin;
  final bool isFirstSec;

  const BinTileWidget({Key? key, required this.bin, required this.sec, required this.isFirstSec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {
        sec.setSectionExpanded(!sec.isSectionExpanded());
      },
      child: Container(
        decoration: const BoxDecoration(
          color: MyColors.binGreen,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  sec.setSectionExpanded(!sec.isSectionExpanded());
                },
                icon: Icon(
                  sec.isSectionExpanded() ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                )),
            const SizedBox(width: 12),
            const SizedBox(width: 8),
            Text(
              "Bin ${bin.bin} ${sec.items.length}",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              height: 25,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: MyColors.black3.withOpacity(0.5))),
              child: Text(
                "Containers: ${sec.items.length}",
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContainerSection extends ExpandableListSection<FlightTag> {
  final WidgetRef ref;
  final TagContainer con;
  final List<FlightTag> allTags;

  ContainerSection({required this.con, required this.allTags, required this.ref});

  @override
  List<FlightTag>? getItems() {
    Position? selectedPos = ref.watch(selectedPosInDetails);

    List<FlightTag> itms = allTags.where((element) => selectedPos == null || selectedPos.id == element.currentPosition).where((element) {
      return ((selectedPos == null || element.currentPosition == selectedPos.id) && element.tagPositions.first.container?.id == con.id) || (element.tagPositions.first.container?.id == null && con.isBulk);
    }).toList();
    return itms;
  }

  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedContainers);
    return !expandeds.contains(con.id);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedContainers.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [con.id!];
    } else {
      expandeds.state = expandeds.state.where((element) => element != con.id).toList();
    }
  }

  List<FlightTag> get items {
    Position? selectedPos = ref.watch(selectedPosInDetails);
    return allTags.where((element) {
      // if(element.tagPositions.first.container?.id==null){
      //   return con.isBulk;
      // }else{
      //   element.tagPositions.first.container!.id == con.id;
      // }
      return (selectedPos == null || selectedPos.id == element.currentPosition) && element.tagPositions.first.container?.id == con.id || (element.tagPositions.first.container?.id == null && con.isBulk);
    }).toList();
  }

  bool get isBulk => con.isBulk;
}

class BinSection extends ExpandableListSection<TagContainer> {
  final WidgetRef ref;
  final Bin bin;
  final List<TagContainer> allCons;
  final FlightDetails fd;

  BinSection({required this.bin, required this.allCons, required this.ref, required this.fd});

  @override
  List<TagContainer>? getItems() {
    List<TagContainer> results= [];
    if (fd.tagList.any((element) => element.getContainerID == null && element.tagPositions.first.binID == bin.id)) {
      results =  allCons.where((element) => element.getTags(fd).where((t) => t.tagPositions.first.binID==bin.id).isNotEmpty).toList() + [TagContainer.bulk(2)];
    }else{
      results = allCons.where((element) => element.getTags(fd).where((t) => t.tagPositions.first.binID==bin.id).isNotEmpty).toList();
    }

    // results =  results.where((e) =>(e.isBulk || e.getTags(fd).isNotEmpty) && e.getTags(fd).any((element) {
    //   // print(element.tagPositions.first.binID==bin.id);
    //   return true;
    //   return   element.tagPositions.first.binID==bin.id;
    // })).toList();
    return results;
  }


  @override
  bool isSectionExpanded() {
    List<int> expandeds = ref.watch(expandedBins);
    return !expandeds.contains(bin.id);
  }

  @override
  void setSectionExpanded(bool expanded) {
    final expandeds = ref.watch(expandedBins.notifier);
    if (!expanded) {
      expandeds.state = expandeds.state + [bin.id!];
    } else {
      expandeds.state = expandeds.state.where((element) => element != bin.id).toList();
    }
  }

  List<TagContainer> get items {
    return getItems()!;

    if (fd.tagList.any((element) => element.getContainerID == null && element.tagPositions.first.binID == bin.id)) {
      return allCons + [TagContainer.bulk(2)];
    }
    return allCons.where((e) =>e.getTags(fd).isNotEmpty && e.getTags(fd).any((element) => !e.isBulk &&  element.tagPositions.first.binID==bin.id)).toList();
    return allCons;
  }
}

class TagWidget extends StatelessWidget {
  final FlightTag tag;
  final int index;
  final bool isLast;
  final bool hasBinLine;

  const TagWidget({Key? key, required this.tag, required this.index, this.isLast = false, required this.hasBinLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: DataCellWidget(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(width: 8),
                  hasBinLine ? Container(width: 2, height: 40, color: MyColors.binGreen) : const SizedBox(),
                  const SizedBox(width: 60),
                  Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                  Container(
                    width: 40,
                    height: 2,
                    color: MyColors.containerGreen,
                    margin: const EdgeInsets.only(top: 19),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Icon(Icons.circle, color: MyColors.containerGreen, size: 8),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      tag.numString,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ))),
          Expanded(
              flex: 1,
              child: DataCellWidget(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(tag.secString),
              ))),
          Expanded(
              flex: 3,
              child: DataCellWidget(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(tag.dcsInfo?.paxName ?? '-'),
              ))),
          Expanded(
              flex: 1,
              child: DataCellWidget(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(tag.tagPositions.first.getTime()),
              ))),
          Expanded(
              flex: 2,
              child: DataCellWidget(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(tag.tagPositions.first.username),
              ))),
          Expanded(
              flex: 1,
              child: DataCellWidget(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(tag.tagPositions.first.indexInPosition.toString()),
              ))),
        ],
      ),
    );
  }
}

class DataCellWidget extends StatelessWidget {
  final Widget child;

  const DataCellWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: MyColors.lineColor))),
      child: child,
    );
  }
}

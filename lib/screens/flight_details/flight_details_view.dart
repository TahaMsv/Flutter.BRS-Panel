import 'dart:math';

import 'package:artemis_ui_kit/artemis_ui_kit.dart';
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
          DotButton(
            size: 35,
            onPressed: () {
              // myFlightsController.goAddFlight();
            },
            icon: Icons.add,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 12),
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
          Expanded(flex:2,child: const SizedBox(width: 12)),
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
                      flex: 3,
                      child: DetailsWidget(
                        details: d,
                        posList: posList,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: DetailsChart(
                          details: d,
                          posList: posList,
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
    Position? selectedPos = ref.watch(selectedPosInDetails);
    String searched = ref.watch(tagSearchProvider);
    List<FlightTag> filteredTag = widget.details.tagList.where((e) => e.validateSearch(searched, selectedPos)).toList();

    List<ContainerSection> cons = widget.details.containerList
        .where((element) => selectedPos == null || element.positionID == selectedPos.id)
        .map((e) => ContainerSection(con: e, allTags: filteredTag, ref: ref))
        .toList();

    List<ContainerSection> bulks = widget.posList.map((e) => ContainerSection(con: TagContainer.bulk(e.id), allTags: filteredTag, ref: ref)).toList();
    // ContainerSection bulkSec = ContainerSection(con: TagContainer.bulk(selectedPos?.id), allTags: widget.details.tagList, ref: ref);
    cons = cons + bulks.where((element) => (selectedPos == null || element.con.positionID == selectedPos.id) && element.items.isNotEmpty).toList();
    return ExpandableListView(
      builder: SliverExpandableChildDelegate<FlightTag, ContainerSection>(
          sectionList: cons,
          headerBuilder: (context, sectionIndex, index) {
            TagContainer con = cons[sectionIndex].con;
            return ContainerTileWidget(
              con: con,
              sec: cons[sectionIndex],
            );
          },
          itemBuilder: (context, sectionIndex, itemIndex, index) {
            FlightTag item = cons[sectionIndex].items[itemIndex];
            return TagWidget(tag: item, index: index - sectionIndex);
          }),
    );
    // return Column(
    //   children: [
    //     Container(
    //       color: Colors.white,
    //       child: TabBar(
    //           controller: controller,
    //           tabs: posList
    //               .map((e) => TextButton(
    //                   onPressed: () {
    //                     controller.animateTo(posList.indexOf(e));
    //                   },
    //                   child: Text(e.title)))
    //               .toList()),
    //     ),
    //     Expanded(
    //       child: TabBarView(
    //           controller: controller,
    //           children: posList
    //               .map((e) => PositionDetailsWidget(
    //                     tags: widget.details.tagList
    //                         .where(
    //                           (element) => element.currentPosition == e.id,
    //                         )
    //                         .toList(),
    //                     pos: e,
    //                   ))
    //               .toList()),
    //     ),
    //   ],
    // );
  }
}

class ContainerTileWidget extends StatelessWidget {
  final ContainerSection sec;
  final TagContainer con;

  const ContainerTileWidget({Key? key, required this.con, required this.sec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {
        sec.setSectionExpanded(!sec.isSectionExpanded());
      },
      child: Container(
        decoration: const BoxDecoration(
          color: MyColors.containerGreen,
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
                )),
            const SizedBox(width: 12),
            Container(width: 1.5, height: 40, color: MyColors.binGreen),
            Stack(
              alignment: Alignment.center,
              children: [Container(width: 45, height: 1, color: MyColors.binGreen), con.getImg],
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
                "Tags: ${sec.items.length}",
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
    print(itms.length);
    return itms;
  }

  @override
  bool isSectionExpanded() {
    // return true;
    // if(isBulk) return true;
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

class PositionDetailsWidget extends StatelessWidget {
  final Position pos;
  final List<FlightTag> tags;

  const PositionDetailsWidget({Key? key, required this.tags, required this.pos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListView.builder(
      itemBuilder: (c, i) => TagWidget(
        tag: tags[i],
        index: i,
      ),
      itemCount: tags.length,
    );
  }
}

class TagWidget extends StatelessWidget {
  final FlightTag tag;
  final int index;

  const TagWidget({Key? key, required this.tag, required this.index}) : super(key: key);

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
                children: [
                  const SizedBox(width: 12),
                  Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: TextStyle(color: MyColors.indexColor.withOpacity(0.3), fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(width: 48),
                  const Spacer(),
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

  DataCellWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: MyColors.lineColor))),
      child: child,
    );
  }
}

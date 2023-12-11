import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:brs_panel/core/abstracts/failures_abs.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/core/util/handlers/failure_handler.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyCheckBoxButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../widgets/MyFieldPicker.dart';
import '../data_tables/assigned_containers_data_table.dart';
import '../data_tables/available_containers_data_table.dart';
import '../flights_controller.dart';

class FlightContainerListDialog extends StatefulWidget {
  final Flight flight;
  final List<TagContainer> cons;
  final List<String> destList;

  const FlightContainerListDialog({Key? key, required this.cons, required this.flight, required this.destList})
      : super(key: key);

  @override
  State<FlightContainerListDialog> createState() => _FlightContainerListDialogState();
}

class _FlightContainerListDialogState extends State<FlightContainerListDialog> {
  final FlightsController myFlightsController = getIt<FlightsController>();
  final NavigationService navigationService = getIt<NavigationService>();
  late List<TagContainer> assigned;
  late List<TagContainer> available;
  TextEditingController availableSearchC = TextEditingController();
  TextEditingController assignedSearchC = TextEditingController();
  List<ClassType> classes = [];
  List<String> destList = [];
  List<TagType> typeList = [];

  // late Airport dest;
  late String? dest;

  // List<Airport?> availableDests = [];
  List<String?> availableDests = [];
  Spot? spot;
  AirportPositionSection? airportPositionSection;

  @override
  void initState() {
    // dest = BasicClass.getAirportByCode(widget.flight.from)!;
    dest = widget.flight.to;
    // destList.add(dest!);
    destList = List.from(widget.destList);
    classes.add(BasicClass.systemSetting.classTypeList.first);
    availableDests = List.from(widget.destList);
    assigned = widget.cons.where((element) => element.flightID != null).toList();
    available =
        widget.cons.where((element) => element.flightID == null && !assigned.any((as) => element.id == as.id)).toList();
    availableSearchC.addListener(() {
      setState(() {});
    });
    assignedSearchC.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<TagContainer> assignedList =
        assigned.where((element) => element.validateSearch(assignedSearchC.text)).toList();
    List<TagContainer> availableList =
        available.where((element) => element.validateSearch(availableSearchC.text)).toList();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.2),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                const Text("Flight Container List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(width: 12),
                FlightBanner(flight: widget.flight),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const Divider(height: 1),
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.lineColor))),
              // padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Available", style: TextStyles.styleBold16Grey),
                          const SizedBox(width: 24),
                          Expanded(
                            child: MyTextField(
                              height: 35,
                              prefixIcon: const Icon(Icons.search),
                              controller: availableSearchC,
                              showClearButton: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: MyColors.evenRow,
                      child: const Text("Section & TagType", style: TextStyles.styleBold16Grey),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Text("Assigned", style: TextStyles.styleBold16Grey),
                        const SizedBox(width: 24),
                        Expanded(
                          child: MyTextField(
                            height: 35,
                            prefixIcon: const Icon(Icons.search),
                            controller: assignedSearchC,
                            showClearButton: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                            child: SfDataGrid(
                                headerGridLinesVisibility: GridLinesVisibility.both,
                                selectionMode: SelectionMode.none,
                                horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                                sortingGestureType: SortingGestureType.doubleTap,
                                gridLinesVisibility: GridLinesVisibility.vertical,
                                allowSorting: true,
                                // shrinkWrapColumns: true,
                                headerRowHeight: 35,
                                source: AvailableContainerDataSource(
                                  cons: availableList,
                                  onAdd: (e) async {
                                    if (typeList.isEmpty) {
                                      FailureHandler.handle(ValidationFailure(
                                          code: 1, msg: "Select Valid Types for Container!", traceMsg: ''));
                                      return;
                                    }
                                    if (airportPositionSection == null) {
                                      FailureHandler.handle(
                                          ValidationFailure(code: 1, msg: "Section is Required!", traceMsg: ''));
                                      return;
                                    }
                                    if (airportPositionSection!.spotRequired && spot == null) {
                                      FailureHandler.handle(ValidationFailure(
                                          code: 1, msg: "Selected Section Requires Spot!", traceMsg: ''));
                                      return;
                                    }

                                    e.tagTypeIds = typeList.map((e) => e.id.toString()).join(",");
                                    e.sectionID = airportPositionSection!.id;
                                    e.spotID = spot?.id;
                                    final a =
                                        await myFlightsController.flightAddRemoveContainer(widget.flight, e, true);
                                    if (a != null) {
                                      available.removeWhere((element) => element.id == a.id);
                                      assigned.insert(0, a);
                                      setState(() {});
                                    }
                                  },
                                ),
                                columns: AvailableContainerDataTableColumn.values
                                    .map(
                                      (e) => GridColumn(
                                        columnName: e.name,

                                        label: Center(
                                            child: Text(
                                          e.label.capitalizeFirst!,
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                        // columnWidthMode: ColumnWidthMode.fill
                                        width: width * 0.8 * 0.2 * e.width,
                                      ),
                                    )
                                    .toList())
                            // child: Container(
                            //   child: ListView.builder(
                            //     itemBuilder: (c, i) {
                            //       TagContainer e = availableList[i];
                            //       e = e.copyWith(destination: dest, destList: destList.join(","), classList: classes.map((e) => e.abbreviation).join(","));
                            //       return AvailableContainerWidget(
                            //         con: e,
                            //         index: i,
                            //         onAdd: () async {
                            //           final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, true);
                            //           if (a != null) {
                            //             available.removeWhere((element) => element.id == a.id);
                            //             assigned.add(a);
                            //             setState(() {});
                            //           }
                            //         },
                            //       );
                            //     },
                            //     itemCount: availableList.length,
                            //   ),
                            // ),
                            ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 12),
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: const BoxDecoration(
                            color: MyColors.evenRow,
                            border: Border.symmetric(
                              vertical: BorderSide(color: MyColors.lineColor, width: 2),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView(
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
                                children: BasicClass.systemSetting.tagTypeList
                                    .where((element) => element.label.isNotEmpty)
                                    .map(
                                      (e) => SizedBox(
                                        width: double.infinity,
                                        child: MyCheckBoxButton(
                                            value: typeList.contains(e),
                                            onChanged: (v) {
                                              if (v) {
                                                typeList.add(e);
                                              } else if (typeList.length > 1 || true) {
                                                typeList.remove(e);
                                              }
                                              setState(() {});
                                            },
                                            label: e.label),
                                      ),
                                    )
                                    .toList()),
                            const SizedBox(height: 12),
                            const Divider(height: 24),
                            const SizedBox(height: 12),
                            MyFieldPicker<AirportPositionSection>(
                              items: BasicClass.getAllAirportSections4()
                                  .where((element) =>
                                      widget.flight.validAssignContainerPositions.contains(element.position) &&
                                      element.canHaveContainer)
                                  .toList(),
                              label: "Airport Section",
                              itemToString: (item) => item.label,
                              value: airportPositionSection,
                              onChange: (as) {
                                airportPositionSection = as;
                                if (as == null || !as.spotRequired) {
                                  spot = null;
                                }
                                if (as != null && as.spotRequired) {
                                  spot = (BasicClass.userSetting.shootList
                                              .firstWhereOrNull((element) => element.id == airportPositionSection?.id)
                                              ?.spotList ??
                                          [])
                                      .firstWhereOrNull(
                                          (element) => !assigned.map((e) => e.spotID).contains(element.id));
                                }
                                setState(() {});
                              },
                            ),
                            (airportPositionSection?.spotRequired ?? false)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: MyFieldPicker<Spot>(
                                      items: BasicClass.userSetting.shootList
                                              .firstWhereOrNull((element) => element.id == airportPositionSection?.id)
                                              ?.spotList ??
                                          [],
                                      // items: [],
                                      label: "Spot",

                                      itemToString: (item) =>
                                          item.spot +
                                          (assignedList.any((element) => element.spotID == item.id) ? "  (Used)" : ""),
                                      value: spot,
                                      onChange: (s) {
                                        spot = s;
                                        setState(() {});
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: SfDataGrid(
                        horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        selectionMode: SelectionMode.none,
                        columnSizer: ColumnSizer(),
                        sortingGestureType: SortingGestureType.doubleTap,
                        gridLinesVisibility: GridLinesVisibility.vertical,
                        shrinkWrapColumns: true,
                        allowSorting: true,
                        headerRowHeight: 35,
                        source: AssignedContainerDataSource(
                          cons: assignedList.where((element) => element.flightID == widget.flight.id).toList(),
                          onDelete: (e) async {
                            final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, false);
                            if (a != null) {
                              assigned.removeWhere((element) => element.id == a.id);
                              available.add(a);
                              setState(() {});
                            }
                          },
                        ),
                        columns: AssignedContainerDataTableColumn.values
                            .map(
                              (e) => GridColumn(
                                  columnName: e.name,
                                  label: Center(
                                      child: Text(
                                    e.label.capitalizeFirst!,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  // columnWidthMode: ColumnWidthMode.fill
                                  width: width * 0.8 * 0.6 * e.width),
                            )
                            .toList()),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const Divider(height: 1),
            // Container(
            //   // height: 200,
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //           child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text("Destination", style: TextStyles.styleBold16Grey),
            //           Column(
            //             children: widget.destList
            //                 .map((e) => MyRadioButton(
            //                     value: dest == e,
            //                     onChange: (v) {
            //                       if (v) {
            //                         dest = e;
            //                       }
            //                       setState(() {});
            //                     },
            //                     label: e!))
            //                 .toList(),
            //           ),
            //         ],
            //       )),
            //       const VerticalDivider(thickness: 2),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text("Allowed Dest List", style: TextStyles.styleBold16Grey),
            //             Column(
            //               children: widget.destList
            //                   .map(
            //                     (e) => MyCheckBoxButton(
            //                         value: destList.contains(e),
            //                         onChanged: (v) {
            //                           if (v) {
            //                             destList.add(e);
            //                           } else if (destList.length > 1) {
            //                             destList.remove(e);
            //                           }
            //                           setState(() {});
            //                         },
            //                         label: e),
            //                   )
            //                   .toList(),
            //             )
            //           ],
            //         ),
            //       ),
            //       const VerticalDivider(thickness: 2),
            //       Expanded(
            //           child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text("Allowed Class List", style: TextStyles.styleBold16Grey),
            //           Column(
            //               children: BasicClass.systemSetting.classTypeList
            //                   .map(
            //                     (e) => MyCheckBoxButton(
            //                         value: classes.contains(e),
            //                         onChanged: (v) {
            //                           if (v) {
            //                             classes.add(e);
            //                           } else if (classes.length > 1) {
            //                             classes.remove(e);
            //                           }
            //                           setState(() {});
            //                         },
            //                         label: e.title),
            //                   )
            //                   .toList())
            //         ],
            //       )),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 12),
              child: Row(
                children: [
                  const Spacer(),
                  MyButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    label: "Done",
                    color: theme.primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AvailableContainerWidget extends StatelessWidget {
  static FlightsController myFlightsController = getIt<FlightsController>();
  final TagContainer con;
  final int index;
  final void Function() onAdd;

  const AvailableContainerWidget({Key? key, required this.con, required this.index, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          con.getImg,
          const SizedBox(width: 8),
          Text(con.code, style: TextStyles.styleBold16Black),
          const SizedBox(width: 8),
          const Spacer(),
          const ArtemisCardField(title: "", value: ''),
          DotButton(
            icon: Icons.add,
            size: 25,
            color: Colors.blueAccent,
            onPressed: onAdd,
          )
        ],
      ),
    );
  }
}

class AssignedContainerWidget extends StatelessWidget {
  static FlightsController myFlightsController = getIt<FlightsController>();
  final TagContainer con;
  final int index;
  final void Function() onDelete;

  const AssignedContainerWidget({Key? key, required this.con, required this.index, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 6,
              child: Row(
                children: [
                  con.getImg,
                  const SizedBox(width: 8),
                  Text(con.code, style: TextStyles.styleBold16Black),
                ],
              )),
          Expanded(
              flex: 2,
              child: ArtemisCardField(
                title: "Position",
                value: con.getPosition?.title ?? '-',
                valueColor: con.getPosition?.getColor ?? Colors.black87,
              )),
          Expanded(flex: 2, child: Text(con.tagCount.toString())),
          Expanded(flex: 6, child: Text("(${con.dest}) ${con.destList}")),
          Expanded(flex: 2, child: Text(con.classTypeList.join(", "))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DotButton(
                  icon: Icons.delete,
                  color: Colors.red,
                  onPressed: (con.tagCount) > 0 ? null : onDelete,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColumnHeaderWidget extends StatelessWidget {
  final int flex;
  final String label;

  const ColumnHeaderWidget({Key? key, this.flex = 1, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: MyColors.black1, fontSize: 12),
          ),
        ));
  }
}

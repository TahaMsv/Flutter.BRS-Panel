import 'dart:io';
import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyCheckBoxButton.dart';
import 'package:brs_panel/widgets/MyFieldPicker.dart';
import 'package:brs_panel/widgets/MyRadioButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/user_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';

import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../flights_controller.dart';

class FlightContainerListDialog extends StatefulWidget {
  final Flight flight;
  final List<TagContainer> cons;

  const FlightContainerListDialog({Key? key, required this.cons, required this.flight}) : super(key: key);

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

  // late Airport dest;
  late String? dest;

  // List<Airport?> availableDests = [];
  List<String?> availableDests = [];

  @override
  void initState() {
    // dest = BasicClass.getAirportByCode(widget.flight.from)!;
    dest = widget.flight.to;
    destList.add(dest!);
    classes.add(BasicClass.systemSetting.classTypeList.first);
    availableDests = widget.flight.destinations;
    assigned = widget.cons.where((element) => element.flightScheduleId != null).toList();
    available = widget.cons.where((element) => element.flightScheduleId == null && !assigned.any((as) => element.id == as.id)).toList();
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
    double width = Get.width;
    double height = Get.height;
    List<TagContainer> assignedList = assigned.where((element) => element.validateSearch(assignedSearchC.text)).toList();
    List<TagContainer> availableList = available.where((element) => element.validateSearch(availableSearchC.text)).toList();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.15, vertical: height * 0.2),
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
              // height: 200,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Destination", style: TextStyles.styleBold16Grey),
                      Column(
                        children: availableDests
                            .map((e) => MyRadioButton(
                                value: dest == e,
                                onChange: (v) {
                                  if (v) {
                                    dest = e;
                                  }
                                  setState(() {});
                                },
                                label: e!))
                            .toList(),
                      ),
                    ],
                  )),
                  const VerticalDivider(thickness: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Allowed Dest List", style: TextStyles.styleBold16Grey),
                        Column(
                          children: availableDests
                              .map(
                                (e) => MyCheckBoxButton(
                                    value: destList.contains(e),
                                    onChanged: (v) {
                                      if (v) {
                                        destList.add(e!);
                                      } else if (destList.length > 1) {
                                        destList.remove(e);
                                      }
                                      setState(() {});
                                    },
                                    label: e!),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 2),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Allowed Class List", style: TextStyles.styleBold16Grey),
                      Column(
                          children: BasicClass.systemSetting.classTypeList
                              .map(
                                (e) => MyCheckBoxButton(
                                    value: classes.contains(e),
                                    onChanged: (v) {
                                      if (v) {
                                        classes.add(e);
                                      } else if (classes.length > 1) {
                                        classes.remove(e);
                                      }
                                      setState(() {});
                                    },
                                    label: e.title),
                              )
                              .toList())
                    ],
                  )),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
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
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemBuilder: (c, i) {
                                TagContainer e = availableList[i];
                                e = e.copyWith(
                                  destination: dest,
                                  destList: destList.join(","),
                                  classList: classes.map((e) => e.abbreviation).join(",")
                                );
                                return AvailableContainerWidget(
                                  con: e,
                                  index: i,
                                  onAdd: () async {
                                    final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, true);
                                    if (a != null) {
                                      available.removeWhere((element) => element.id == a.id);
                                      assigned.add(a);
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                              itemCount: availableList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 12),
                  const VerticalDivider(width: 5, thickness: 5),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
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
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                              itemBuilder: (c, i) {
                                TagContainer e = assignedList[i];
                                return AssignedContainerWidget(
                                    con: e,
                                    index: i,
                                    onDelete: () async {
                                      final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, false);
                                      if (a != null) {
                                        assigned.removeWhere((element) => element.id == a.id);
                                        available.add(a);
                                        setState(() {});
                                      }
                                    });
                              },
                              itemCount: assignedList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
              child: Row(
                children: [
                  const Spacer(),
                  MyButton(
                    onPressed: () {},
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

  const AvailableContainerWidget({Key? key, required this.con, required this.index, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          con.getImg,
          const SizedBox(width: 8),
          Text(con.code,style: TextStyles.styleBold16Black),
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

  const AssignedContainerWidget({Key? key, required this.con, required this.index, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: index.isEven ? MyColors.evenRow : MyColors.oddRow),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          con.getImg,
          const SizedBox(width: 8),
          Expanded(child: Text(con.code,style: TextStyles.styleBold16Black)),
          Expanded(child: ArtemisCardField(title: "Position", value:con.getPosition?.title??'-',valueColor: con.getPosition?.getColor??Colors.black87,)),
          Expanded(child: ArtemisCardField(title: "Tag Count", value:con.tagCount.toString())),
          Expanded(child: ArtemisCardField(title: "Dest List", value:"(${con.destination??''}) ${con.destination??''}")),
          Expanded(child: ArtemisCardField(title: "Class Types", value:con.classList??'-')),
          DotButton(
            icon: Icons.delete,
            color: Colors.red,
            onPressed:(con.tagCount??0)>0?null: onDelete,
          )
        ],
      ),
    );
  }
}

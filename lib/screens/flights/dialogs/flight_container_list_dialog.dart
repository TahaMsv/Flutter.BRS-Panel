import 'dart:io';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/flight_details_class.dart';
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

  @override
  void initState() {
    assigned = widget.cons.where((element) => element.flightID != null).toList();
    available = widget.cons.where((element) => element.flightID == null && !assigned.any((as) => element.id == as.id)).toList();
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

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.25, vertical: height * 0.2),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                const Text("FlightContainerList", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    icon: const Icon(Icons.close))
              ],
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
                          padding: const EdgeInsets.only(left: 24, top: 12),
                          child: Row(
                            children: [
                              const Text("Available Containers", style: TextStyles.styleBold16Grey),
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
                            padding: const EdgeInsets.all(18),
                            child: SingleChildScrollView(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: available
                                    .where((element) => element.validateSearch(availableSearchC.text))
                                    .map((e) => Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: MyColors.greyBlue, width: 2)),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      e.getImg,
                                      const SizedBox(width: 8),
                                      Text(e.code),
                                      const SizedBox(width: 8),
                                      DotButton(
                                        icon: Icons.add,
                                        color: Colors.blueAccent,
                                        onPressed: () async {
                                          final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, true);
                                          if (a != null) {
                                            available.removeWhere((element) => element.id == a.id);
                                            assigned.add(a);
                                            setState(() {});
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  // child: ActionChip(
                                  //   side: const BorderSide(color: MyColors.green,width: 2),
                                  //   avatar: e.getImg,
                                  //   shadowColor: Colors.red,
                                  //   surfaceTintColor: Colors.red,
                                  //   onPressed: (){
                                  //   },
                                  //   label: Text(e.code),
                                  // ),
                                ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 24, top: 12),
                          child: Row(
                            children: [
                              const Text("Assigned Containers", style: TextStyles.styleBold16Grey),
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

                            padding: const EdgeInsets.all(18),
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: assigned
                                    .where((element) => element.validateSearch(assignedSearchC.text))
                                    .map((e) => Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: MyColors.green, width: 2)),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      e.getImg,
                                      const SizedBox(width: 8),
                                      Text(e.code),
                                      const SizedBox(width: 8),
                                      DotButton(
                                        icon: Icons.delete,
                                        color: Colors.red,
                                        onPressed: () async {
                                          final a = await myFlightsController.flightAddRemoveContainer(widget.flight, e, true);
                                          if (a != null) {
                                            assigned.removeWhere((element) => element.id == a.id);
                                            available.add(a);
                                            setState(() {});
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ))
                                    .toList(),
                              ),
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
                    onPressed: () => navigationService.popDialog(),
                    label: "Cancel",
                    color: MyColors.greyishBrown,
                  ),
                  const SizedBox(width: 12),
                  MyButton(
                    onPressed: () {},
                    label: "Save",
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

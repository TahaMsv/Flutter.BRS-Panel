import 'dart:math';

import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:brs_panel/core/classes/containers_plan_class.dart';
import 'package:brs_panel/core/constants/assest.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/screens/flights/data_tables/assigned_containers_data_table.dart';
import 'package:brs_panel/screens/flights/data_tables/available_containers_data_table.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyCheckBoxButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../flight_details/flight_details_controller.dart';
import '../flights_controller.dart';

class FlightContainersPlanDialog extends StatefulWidget {
  final Flight flight;
  final ContainersPlan plan;

  const FlightContainersPlanDialog({Key? key, required this.plan, required this.flight}) : super(key: key);

  @override
  State<FlightContainersPlanDialog> createState() => _FlightContainersPlanDialogState();
}

class _FlightContainersPlanDialogState extends State<FlightContainersPlanDialog> {
  final FlightsController myFlightsController = getIt<FlightsController>();
  final NavigationService navigationService = getIt<NavigationService>();
  late ContainersPlan plan;

  @override
  void initState() {
    plan = ContainersPlan.fromJson(widget.plan.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    const TextStyle headerStyles = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.2),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                const Text("Containers Plan List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
            plan.statustics.isEmpty
                ? const SizedBox()
                : Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.black3),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueAccent.withOpacity(0.1)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(plan.statustics))
                      ],
                    ),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tag Type",
                                    style: headerStyles,
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AssetImages.cart, width: 100, height: 50),
                                    Text(
                                      "(${plan.cartCap})",
                                      style: headerStyles,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AssetImages.uld, width: 100, height: 50),
                                    Text(
                                      "(${plan.uldCap})",
                                      style: headerStyles,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Expanded(
                              child: Center(
                                  child: Text(
                            "# Bags",
                            style: headerStyles,
                          ))),
                          const SizedBox(width: 24),
                        ],
                      ),
                      ...plan.planData.map((e) {
                        int index = plan.planData.indexOf(e);
                        TagType type = BasicClass.getTagTypeByID(e.tagTypeId)!;
                        if (type.label.isEmpty) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      MyButton(
                                        label: "Print",
                                        onPressed: () async {
                                          await getIt<FlightsController>().flightGetPlanFile(flight: widget.flight, typeID: e.tagTypeId);
                                        },
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                          decoration: BoxDecoration(color: type.getColor, borderRadius: BorderRadius.circular(5)),
                                          child: Text(
                                            type.label,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: type.getTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                    ],
                                  )),
                              Expanded(
                                flex: 2,
                                child: PlanInputWidget(
                                    value: e.cartCount,
                                    onChange: (v) {
                                      e = e.copyWith(cartCount: v);
                                      var newPD = plan.planData;
                                      newPD.replaceRange(index, index + 1, [e]);
                                      plan = plan.copyWith(planData: newPD);
                                      setState(() {});
                                    }),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: PlanInputWidget(
                                    value: e.uldCount,
                                    onChange: (v) {
                                      e = e.copyWith(uldCount: v);
                                      var newPD = plan.planData;
                                      newPD.replaceRange(index, index + 1, [e]);
                                      plan = plan.copyWith(planData: newPD);
                                      setState(() {});
                                    }),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                "${(e.uldCount * plan.uldCap) + (e.cartCount * plan.cartCap)}",
                                style: headerStyles,
                              ))),
                              const SizedBox(width: 24),
                            ],
                          ),
                        );
                      }).toList()
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetImages.cart, height: 50),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetImages.uld, height: 50),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Expanded(
                                child: Center(
                                    child: Text(
                              "# Bags",
                              style: headerStyles,
                            ))),
                            const SizedBox(width: 24),
                          ],
                        ),
                        ...plan.lastFlightPlanData.map((e) {
                          int index = plan.lastFlightPlanData.indexOf(e);
                          TagType type = BasicClass.getTagTypeByID(e.tagTypeId)!;
                          if (type.label.isEmpty) return const SizedBox();

                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: PlanInputWidget(canEdit: false, value: e.cartCount, onChange: (v) {}),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: PlanInputWidget(canEdit: false, value: e.uldCount, onChange: (v) {}),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                  "${(e.uldCount * plan.uldCap) + (e.cartCount * plan.cartCap)}",
                                  style: headerStyles,
                                ))),
                                const SizedBox(width: 24),
                              ],
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 12),
              child: Row(
                children: [
                  const Spacer(),
                  MyButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    label: "Cancel",
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 24),
                  MyButton(
                    onPressed: () async {
                      await myFlightsController.flightSavePlans(flight: widget.flight, newPlan: plan);
                    },
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

class PlanInputWidget extends StatefulWidget {
  final bool canEdit;
  int value;
  void Function(int) onChange;

  PlanInputWidget({
    Key? key,
    required this.value,
    required this.onChange,
    this.canEdit = true,
  }) : super(key: key);

  @override
  State<PlanInputWidget> createState() => _PlanInputWidgetState();
}

class _PlanInputWidgetState extends State<PlanInputWidget> {
  TextEditingController valueC = TextEditingController();

  @override
  void initState() {
    valueC.text = widget.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;
    return Container(
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              prefix: !widget.canEdit
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: DotButton(
                        icon: Icons.remove_circle,
                        onPressed: () {
                          int newVal = max(0, int.parse(valueC.text) - 1);
                          valueC = tcFromIntValue(newVal);
                          widget.onChange(newVal);
                          setState(() {});
                        },
                      ),
                    ),
              suffix: !widget.canEdit
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: DotButton(
                        icon: Icons.add_circle,
                        onPressed: () {
                          int newVal = int.parse(valueC.text) + 1;
                          valueC = tcFromIntValue(newVal);
                          widget.onChange(newVal);
                          setState(() {});
                        },
                      ),
                    ),
              controller: valueC,
              enabled: widget.canEdit,
              textAlign: TextAlign.center,
              inputFormatters: [MyInputFormatter.justNumber],
            ),
          ),
        ],
      ),
    );
  }
}

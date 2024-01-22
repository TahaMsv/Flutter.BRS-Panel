import 'dart:math';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/constants/assest.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/classes/containers_plan_class.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../widgets/MyFieldPicker.dart';
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
  bool show = true;
  Spot? spot;
  AirportPositionSection? airportPositionSection;
  late List<int> allTagTypesId;

  @override
  void initState() {
    plan = ContainersPlan.fromJson(widget.plan.toJson());
    print("Plan sectionID ${plan.sectionID}  Plan spot ${plan.spotID}");
    airportPositionSection = BasicClass.getAirportSectionByID(plan.sectionID);
    spot = (BasicClass.shootList.firstWhereOrNull((element) => element.id == plan.sectionID)?.spotList ?? []).firstWhereOrNull((e) => e.id == plan.spotID);
    List<int> temp = [];
    plan.planData.where((e) {
      TagType type = BasicClass.getTagTypeByID(e.tagTypeId.first)!;
      if (type.label.isNotEmpty && e.tagTypeId.length == 1 && !temp.contains(e.tagTypeId.first)) {
        temp.add(e.tagTypeId.first);
      }
      return type.label.isNotEmpty;
    }).toList();
    allTagTypesId = temp;
    super.initState();
  }

  onChangeTagTypes(int value, PlanDatum data) {
    int id = allTagTypesId[value];
    int index = plan.planData.indexOf(data);
    List<int>? tagTypeId = plan.planData[index].tagTypeId;
    tagTypeId.contains(id) ? tagTypeId.remove(id) : tagTypeId.add(id);
    plan.planData[index] = data.copyWith(tagTypeId: tagTypeId);
    setState(() {});
  }

  onChangeCart(int value, PlanDatum data) {
    int index = plan.planData.indexOf(data);
    plan.planData[index] = data.copyWith(cartCount: value);
    setState(() {});
  }

  onChangeUld(int value, PlanDatum data) {
    int index = plan.planData.indexOf(data);
    plan.planData[index] = data.copyWith(uldCount: value);
    setState(() {});
  }

  removeItem(int index) {
    List<PlanDatum> tempPlanData = plan.planData;
    tempPlanData.removeAt(index);
    plan = plan.copyWith(planData: tempPlanData);
    setState(() {});
  }

  bool updateIsPDFEnable(bool isAddedPlanD, PlanDatum data) {
    bool isPDFEnable;
    if (!isAddedPlanD) {
      isPDFEnable = (data.uldCount > 0 || data.cartCount > 0);
    } else {
      isPDFEnable = (data.tagTypeId.length >= 2) && (data.cartCount > 0 || data.uldCount > 0);
    }
    return isPDFEnable;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    const TextStyle headerStyles = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        SizedBox(width: 18),
                        Text("Containers Plan List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(width: 12),
                        Spacer(),
                      ],
                    )),
                IconButton(onPressed: () => navigationService.popDialog(), icon: const Icon(Icons.close))
              ],
            ),
            const Divider(height: 1),
            plan.statustics.isEmpty
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: MyColors.black3), borderRadius: BorderRadius.circular(8), color: Colors.blueAccent.withOpacity(0.1)),
                    padding: const EdgeInsets.all(8),
                    child: Row(children: [Expanded(child: Text(plan.statustics))]),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Padding(padding: const EdgeInsets.all(8), child: FlightBanner(flight: widget.flight)),
                              const Divider(),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Text("Tag Type", style: headerStyles)],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Image.asset(AssetImages.cart, width: 100, height: 50), Text("(${plan.cartCap})", style: headerStyles)],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(AssetImages.uld, width: 100, height: 50),
                                            Text("(${plan.uldCap})", style: headerStyles),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  const Expanded(flex: 2, child: Center(child: Text("# Bags", style: headerStyles))),
                                  const SizedBox(width: 24),
                                ],
                              ),
                            ] +
                            plan.planData.map((e) {
                              int index = plan.planData.indexOf(e);
                              TagType? type = e.tagTypeId.isEmpty ? null : BasicClass.getTagTypeByID(e.tagTypeId.first);
                              bool isAddedPlanD = index > 5;
                              bool isPDFEnable = updateIsPDFEnable(isAddedPlanD, e);
                              return PlanItem(
                                data: e,
                                type: type,
                                flight: widget.flight,
                                plan: plan,
                                index: index,
                                headerStyles: headerStyles,
                                allTagTypesId: allTagTypesId,
                                onChangeTagTypes: (v) => onChangeTagTypes(v, e),
                                onAddCart: (v) => onChangeCart(v, e),
                                onAddUld: (v) => onChangeUld(v, e),
                                removeFunction: () => removeItem(index),
                                isAddedPlanD: isAddedPlanD,
                                isPDFEnable: isPDFEnable,
                              );
                            }).toList() +
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(flex: 9, child: SizedBox()),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: IconButton(
                                        iconSize: 30,
                                        color: MyColors.lightIshBlue,
                                        icon: const Icon(Icons.add_circle),
                                        onPressed: () => setState(() => plan.planData.add(PlanDatum.empty())),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Text("Last Flight: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Spacer(),
                              plan.lastFligt == null
                                  ? const SizedBox()
                                  :
                                  // Text("${plan.lastFligt!.al} ${plan.lastFligt!.flightNumber} - ${plan.lastFligt!.flightDate.format_ddMMMEEE}"),
                                  // const SizedBox(width: 24),
                                  FlightBanner(flight: plan.lastFligt!, mini: true),
                            ],
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DotButton(
                                icon: Icons.arrow_back,
                                onPressed: () {
                                  plan = plan.copyWith(planData: [...plan.lastFlightPlanData]);
                                  // show = false;
                                  setState(() {});
                                  // show = true;
                                  // setState(() {});
                                },
                              ),
                            ),
                            Expanded(
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
                                              children: [Image.asset(AssetImages.cart, height: 50)],
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
                                              children: [Image.asset(AssetImages.uld, height: 50)],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      const Expanded(child: Center(child: Text("# Bags", style: headerStyles))),
                                      const SizedBox(width: 24),
                                    ],
                                  ),
                                  ...plan.lastFlightPlanData.map((e) {
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
                                              child: Text("${(e.uldCount * plan.uldCap) + (e.cartCount * plan.cartCap)}", style: headerStyles),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                        ],
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.greenAccent,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Sum", style: headerStyles)],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("${plan.planData.map((e) => e.cartCount).sum} Cart(s)", style: headerStyles)],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("${plan.planData.map((e) => e.uldCount).sum} ULD(s)", style: headerStyles)],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("${plan.planData.map((e) => (e.uldCount * plan.uldCap) + (e.cartCount * plan.cartCap)).sum} Tag(s)", style: headerStyles),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyFieldPicker<AirportPositionSection>(
                      items: BasicClass.getAllAirportSections4().where((element) => widget.flight.validAssignContainerPositions.contains(element.position) && element.canHaveContainer).toList(),
                      label: "Airport Section",
                      itemToString: (item) => item.label,
                      value: airportPositionSection,
                      onChange: (as) {
                        airportPositionSection = as;
                        if (as == null || !as.spotRequired) spot = null;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: (airportPositionSection?.spotRequired ?? false)
                        ? MyFieldPicker<Spot>(
                            items: BasicClass.shootList.firstWhereOrNull((element) => element.id == airportPositionSection?.id)?.spotList ?? [],
                            label: "Spot",
                            itemToString: (item) => item.spot,
                            value: spot,
                            onChange: (s) => setState(() => spot = s),
                          )
                        : const SizedBox(),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  MyButton(onPressed: navigationService.popDialog, label: "Cancel", color: Colors.grey),
                  const SizedBox(width: 24),
                  MyButton(
                    onPressed: () async {
                      await myFlightsController.flightSavePlans(flight: widget.flight, newPlan: plan, sectionID: airportPositionSection?.id, spotID: spot?.id);
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

class PlanItem extends StatefulWidget {
  const PlanItem({
    Key? key,
    required this.data,
    required this.type,
    required this.flight,
    required this.plan,
    required this.index,
    required this.headerStyles,
    required this.onAddCart,
    required this.onAddUld,
    required this.allTagTypesId,
    required this.onChangeTagTypes,
    required this.removeFunction,
    required this.isAddedPlanD,
    required this.isPDFEnable,
  }) : super(key: key);

  final PlanDatum data;
  final TagType? type;
  final Flight flight;
  final ContainersPlan plan;
  final int index;
  final bool isAddedPlanD;
  final bool isPDFEnable;
  final TextStyle headerStyles;
  final List<int> allTagTypesId;
  final void Function(int) onChangeTagTypes;
  final void Function(int) onAddCart;
  final void Function(int) onAddUld;
  final void Function() removeFunction;

  @override
  State<PlanItem> createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  late TagType? type;
  late ContainersPlan plan;
  late int index;
  late bool isAddedPlanD;

  @override
  void initState() {
    type = widget.type;
    plan = widget.plan;
    index = widget.index;
    isAddedPlanD = widget.isAddedPlanD;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Row(
                children: [
                  DotButton(
                    icon: Icons.picture_as_pdf,
                    color: Colors.red,
                    onPressed: widget.isPDFEnable ? () async => await getIt<FlightsController>().flightGetPlanFile(flight: widget.flight, tagTypeIds: widget.data.tagTypeId) : null,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: isAddedPlanD
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 60),
                            child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // Change this value to 4 if needed
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 2),
                                  itemCount: widget.allTagTypesId.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    TagType type = BasicClass.getTagTypeByID(widget.allTagTypesId[index])!;
                                    if (type.label.isEmpty) return null;
                                    return InkWell(
                                      onTap: () => widget.onChangeTagTypes(index),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: type.getColor.withOpacity(widget.data.tagTypeId.contains(widget.allTagTypesId[index]) ? 1 : 0.6),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          type.label,
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: type.getTextColor.withOpacity(widget.data.tagTypeId.contains(widget.allTagTypesId[index]) ? 1 : 0.6),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(color: type?.getColor, borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              type?.label ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: type?.getTextColor,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 24),
                ],
              )),
          Expanded(
            flex: 3,
            child: PlanInputWidget(value: widget.data.cartCount, onChange: (v) => setState(() => widget.onAddCart(v))),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: PlanInputWidget(value: widget.data.uldCount, onChange: (v) => setState(() => widget.onAddUld(v))),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: isAddedPlanD
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 22),
                      Text("${(widget.data.uldCount * plan.uldCap) + (widget.data.cartCount * plan.cartCap)}", style: widget.headerStyles),
                      InkWell(
                        onTap: () {
                          widget.removeFunction();
                        },
                        child: const Icon(Icons.remove_circle, color: MyColors.red, size: 22),
                      ),
                    ],
                  )
                : Center(
                    child: Text("${(widget.data.uldCount * plan.uldCap) + (widget.data.cartCount * plan.cartCap)}", style: widget.headerStyles),
                  ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class PlanInputWidget extends StatefulWidget {
  final bool canEdit;
  final int value;
  final void Function(int) onChange;

  const PlanInputWidget({Key? key, required this.value, required this.onChange, this.canEdit = true}) : super(key: key);

  @override
  State<PlanInputWidget> createState() => _PlanInputWidgetState();
}

class _PlanInputWidgetState extends State<PlanInputWidget> {
  TextEditingController valueC = TextEditingController();

  @override
  void initState() {
    valueC = tcFromIntValue(widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlanInputWidget oldWidget) {
    // print(widget.value);
    // print("DID");
    valueC = tcFromIntValue(widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

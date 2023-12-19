import 'package:flutter/material.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/airport_section_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/util/basic_class.dart';
import '../../../core/util/handlers/failure_handler.dart';
import '../../../initialize.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MyCheckBoxButton.dart';
import '../../../widgets/MyDropDown.dart';
import '../../../widgets/MySwitchButton.dart';
import '../../../widgets/MyTextField.dart';
import '../airport_sections_controller.dart';

class AddUpdateSectionDialog extends StatefulWidget {
  const AddUpdateSectionDialog({Key? key, this.section}) : super(key: key);
  final Section? section;

  @override
  State<AddUpdateSectionDialog> createState() => _AddUpdateAirportCartDialogState();
}

class _AddUpdateAirportCartDialogState extends State<AddUpdateSectionDialog> {
  final AirportSectionsController controller = getIt<AirportSectionsController>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController codeC = TextEditingController();
  int? id;
  bool tag = true;
  bool con = false;
  bool bin = false;
  bool spotRequired = false;
  bool isMain = false;
  bool isGround = false;
  Position? selectedPosition;
  int? selectedOffset;
  List<Section> sections = [];
  List<TextEditingController> textCs = [TextEditingController()];
  bool forceGroundToTrue = false;

  @override
  void initState() {
    if (widget.section != null) {
      id = widget.section!.id;
      nameC.text = widget.section!.label;
      codeC.text = widget.section!.code;
      selectedPosition = BasicClass.systemSetting.positions.firstWhereOrNull((e) => e.id == widget.section!.position);
      selectedOffset = widget.section!.offset;
      isGround = widget.section!.isGround ?? false;
      isMain = widget.section!.isMainSection;
      tag = widget.section!.canHaveTag;
      con = widget.section!.canHaveContainer;
      bin = widget.section!.canHaveBin;
      spotRequired = widget.section!.spotRequired;
      textCs = widget.section!.spots.map((e) => TextEditingController(text: e.label)).toList();
      sections = widget.section!.sections;
    }
    forceGroundToTrue = controller.checkForceGround(widget.section);
    if (forceGroundToTrue) isGround = forceGroundToTrue;
    super.initState();
  }

  double getOffsetDouble(int offset, isFromTop) {
    switch (offset) {
      case 1:
        return isFromTop ? 0 : 0;
      case 2:
        return isFromTop ? 0 : 40;
      case 3:
        return isFromTop ? 0 : 80;
      case 4:
        return isFromTop ? 40 : 0;
      case 5:
        return isFromTop ? 40 : 40;
      case 6:
        return isFromTop ? 40 : 80;
      default:
        return isFromTop ? 0 : 0;
    }
  }

  checkBoxAction(int i, bool b) {
    switch (i) {
      case 0: //tag
        if (b) {
          tag = true;
          con = false;
          bin = false;
          spotRequired = false;
        } else {
          tag = false;
        }
        break;
      case 1: //container
        if (b) {
          tag = false;
          con = true;
          bin = false;
        } else {
          con = false;
          spotRequired = false;
        }
        break;
      case 2: //bin
        if (b) {
          tag = false;
          con = false;
          bin = true;
          spotRequired = false;
        } else {
          bin = false;
        }
        break;
      case 3: //spot required
        if (b) {
          tag = false;
          con = true;
          bin = false;
          spotRequired = true;
        } else {
          spotRequired = false;
        }
        break;
    }
    setState(() {});
  }

  String validateData() {
    String msg = '';
    if (codeC.text.isEmpty || codeC.text.length > 10) {
      msg = "Code must not be empty and have at most 10 characters!";
    } else if (!tag && !con && !bin) {
      msg = "You must select one of the 'tag', 'container' and 'bin' options!";
    } else if (selectedPosition == null) {
      msg = "You must select the position!";
    } else if (selectedOffset == null) {
      msg = "You must select the offset!";
    } else if (forceGroundToTrue && !isGround) {
      msg = "Is ground must have been selected!";
    } else if (spotRequired) {
      if (textCs.any((t) => t.text.isEmpty)) msg = "You must fill all the spots!";
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService ns = getIt<NavigationService>();
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    List<Position> positionList = BasicClass.systemSetting.positions;
    List<int> offsetList = [1, 2, 3, 4, 5, 6];
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.5 - 400),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 18),
              Text(widget.section == null ? "Add Section" : "Edit Section", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const Spacer(),
              IconButton(onPressed: ns.pop, icon: const Icon(Icons.close))
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(height: 40, width: 349, child: MyTextField(controller: nameC, label: "Name")),
              const SizedBox(width: 30),
              Container(color: MyColors.lineColor2, width: 1, height: 60),
              const SizedBox(width: 30),
              SizedBox(height: 40, width: 349, child: MyTextField(controller: codeC, label: "Code", required: true)),
              const SizedBox(width: 20),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(children: [
            const SizedBox(width: 20, height: 60),
            MyCheckBoxButton(label: "Tag", value: tag, onChanged: (b) => checkBoxAction(0, b)),
            const SizedBox(width: 30),
            MyCheckBoxButton(label: "Container", value: con, onChanged: (b) => checkBoxAction(1, b)),
            const SizedBox(width: 30),
            MyCheckBoxButton(label: "Bin", value: bin, onChanged: (b) => checkBoxAction(2, b)),
          ]),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            children: [
              const SizedBox(width: 30),
              Container(
                width: 370 / 2,
                alignment: Alignment.centerLeft,
                child: MySwitchButton(
                  value: isMain,
                  onChange: (b) => setState(() => isMain = b),
                  label: "Is Main",
                ),
              ),
              Container(
                width: 370 / 2,
                alignment: Alignment.centerLeft,
                child: MySwitchButton(
                  value: isGround,
                  onChange: (b) => setState(() => isGround = b),
                  label: "Is Ground",
                ),
              ),
              Container(color: MyColors.lineColor2, width: 1, height: 60),
              const SizedBox(width: 20),
              const Text("Position"),
              const SizedBox(width: 20),
              Container(color: MyColors.lineColor2, width: 1, height: 60),
              const SizedBox(width: 20),
              SizedBox(
                  width: 250,
                  child: MyDropDown<Position>(label: "Select", items: positionList, itemToString: (s) => s.title, onSelect: (s) => setState(() => selectedPosition = s), value: selectedPosition)),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            children: [
              const SizedBox(width: 30),
              const Text("Offset"),
              const SizedBox(width: 20),
              Container(color: MyColors.lineColor2, width: 1, height: 60),
              const SizedBox(width: 20),
              SizedBox(
                  width: 250,
                  child: MyDropDown<int>(label: "Select", items: offsetList, itemToString: (i) => i.toString(), onSelect: (i) => setState(() => selectedOffset = i), value: selectedOffset)),
              const SizedBox(width: 30),
              const Text("Preview", style: TextStyle(color: MyColors.brownGrey)),
              const SizedBox(width: 20),
              if (selectedPosition != null)
                Stack(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(9),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: selectedPosition!.getColor)),
                      child: Text(selectedPosition!.title, style: TextStyle(color: selectedPosition!.getColor)),
                    ),
                    if (selectedOffset != null)
                      Positioned(
                          top: getOffsetDouble(selectedOffset!, true),
                          left: getOffsetDouble(selectedOffset!, false),
                          child: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: selectedPosition!.getColor, borderRadius: BorderRadius.circular(4)),
                            child: Text(selectedOffset.toString(), style: const TextStyle(color: MyColors.white3)),
                          )),
                  ],
                ),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
                child: MySwitchButton(value: spotRequired, onChange: (b) => checkBoxAction(3, b), label: "Spot Required"),
              ),
              const SizedBox(width: 40),
              if (spotRequired)
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...textCs.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8, right: 10),
                              child: Row(
                                children: [
                                  if (textCs.length > 1) DotButton(color: MyColors.red, onPressed: () => setState(() => textCs.remove(e)), icon: Icons.remove) else const SizedBox(width: 30),
                                  Container(height: 30, width: 250, margin: const EdgeInsets.only(left: 10), child: MyTextField(label: "Required Spot", controller: e, required: true)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              if (spotRequired)
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: DotButton(
                      onPressed: () => setState(() => textCs.add(TextEditingController())),
                      icon: Icons.add,
                    )),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                const Spacer(),
                MyButton(onPressed: () => ns.popDialog(), label: "Cancel", color: MyColors.greyishBrown),
                const SizedBox(width: 12),
                MyButton(
                  onPressed: () {
                    final String validation = validateData();
                    if (validation.isNotEmpty) {
                      return FailureHandler.handle(ValidationFailure(code: 1, msg: validation, traceMsg: ''));
                    }
                    ns.pop(Section(
                      id: id,
                      label: nameC.text,
                      code: codeC.text,
                      position: selectedPosition?.id ?? 0,
                      offset: selectedOffset ?? 0,
                      isMainSection: isMain,
                      isGround: isGround,
                      groundSectionID: null,
                      canHaveTag: tag,
                      canHaveContainer: con,
                      canHaveBin: bin,
                      spotRequired: spotRequired,
                      spots: textCs.map((e) => SectionSpot(id: null, label: e.text)).toList(),
                      sections: sections,
                    ));
                  },
                  label: "Confirm",
                  color: theme.primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

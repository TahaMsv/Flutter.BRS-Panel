import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/classes/airport_section_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/util/basic_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MyCheckBoxButton.dart';
import '../../../widgets/MyDropDown.dart';
import '../../../widgets/MySwitchButton.dart';
import '../../../widgets/MyTextField.dart';

class AddSectionDialog extends StatefulWidget {
  const AddSectionDialog({Key? key}) : super(key: key);

  @override
  State<AddSectionDialog> createState() => _AddUpdateAirportCartDialogState();
}

class _AddUpdateAirportCartDialogState extends State<AddSectionDialog> {
  final TextEditingController nameC = TextEditingController();
  bool tag = true;
  bool con = true;
  bool bin = true;
  bool spotRequired = true;
  bool isMain = true;
  Position? selectedPosition;
  int? selectedOffset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService ns = getIt<NavigationService>();
    ThemeData theme = Theme.of(context);
    double width = Get.width;
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
              const Text("Add Section", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.close))
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(height: 40, width: 350, child: MyTextField(controller: nameC, label: "Name")),
              const SizedBox(width: 30),
              Container(color: MyColors.lineColor2, width: 1, height: 60),
              const SizedBox(width: 30),
              MyCheckBoxButton(label: "Tag", value: tag, onChanged: (b) => setState(() => tag = b)),
              const SizedBox(width: 30),
              MyCheckBoxButton(label: "Container", value: con, onChanged: (b) => setState(() => con = b)),
              const SizedBox(width: 30),
              MyCheckBoxButton(label: "Bin", value: bin, onChanged: (b) => setState(() => bin = b)),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Row(
            children: [
              const SizedBox(width: 30),
              Container(
                width: 370,
                alignment: Alignment.centerLeft,
                child: MySwitchButton(
                  value: spotRequired,
                  onChange: (b) => setState(() => spotRequired = b),
                  label: "Spot Required",
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
                  child: MyDropDown<Position>(
                      label: "Select",
                      items: positionList,
                      itemToString: (s) => s.title,
                      onSelect: (s) => setState(() => selectedPosition = s),
                      value: selectedPosition)),
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
                  child: MyDropDown<int>(
                      label: "Select",
                      items: offsetList,
                      itemToString: (i) => i.toString(),
                      onSelect: (i) => setState(() => selectedOffset = i),
                      value: selectedOffset)),
            ],
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          Container(
            height: 30,
            margin: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
            child: MySwitchButton(
              value: isMain,
              onChange: (b) => setState(() => isMain = b),
              label: "Is Main",
            ),
          ),
          const Divider(height: 1, color: MyColors.lineColor2),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                const Spacer(),
                MyButton(
                  onPressed: () => ns.popDialog(),
                  label: "Cancel",
                  color: MyColors.greyishBrown,
                ),
                const SizedBox(width: 12),
                MyButton(
                  onPressed: () {
                    //todo validate!
                    ns.pop(Section(
                      id: null,
                      label: nameC.text,
                      position: selectedPosition!.id,
                      offset: selectedOffset!,
                      isMainSection: isMain,
                      canHaveTag: tag,
                      canHaveContainer: con,
                      canHaveBin: bin,
                      spotRequired: spotRequired,
                      sections: [],
                    ));
                  },
                  label: "Add",
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

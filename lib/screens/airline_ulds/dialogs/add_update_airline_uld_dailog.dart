import 'dart:io';
import 'package:brs_panel/core/classes/airline_uld_class.dart';
import 'package:brs_panel/screens/airline_ulds/airline_ulds_controller.dart';
import 'package:brs_panel/screens/airline_ulds/airline_ulds_state.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/MyButton.dart';

import '../../../../core/constants/ui.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../core/abstracts/success_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/util/handlers/success_handler.dart';
import '../../../initialize.dart';

class AddUpdateAirlineDialogDialog extends StatefulWidget {
  final TagContainer? editingUld;

  const AddUpdateAirlineDialogDialog({Key? key, required this.editingUld}) : super(key: key);

  @override
  State<AddUpdateAirlineDialogDialog> createState() => _AddUpdateAirlineDialogDialogState();
}

class _AddUpdateAirlineDialogDialogState extends State<AddUpdateAirlineDialogDialog> {
  final AirlineUldsController myAirlineUldsController = getIt<AirlineUldsController>();

  final NavigationService navigationService = getIt<NavigationService>();
  final TextEditingController codeC = TextEditingController();
  final TextEditingController barcodeC = TextEditingController();

  @override
  void initState() {
    if(widget.editingUld!=null){
      codeC.text = widget.editingUld!.code;
      barcodeC.text = widget.editingUld!.barcode;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;
    bool editMode = widget.editingUld != null;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.4),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 18),
              Text(editMode ? 'Update Airline Dialog' : "Add Airline Dialog", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
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
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                MyTextField(
                  controller: codeC,
                  label: "Code",
                )
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
                  onPressed: () async {
                    final al = myAirlineUldsController.ref.read(selectedAirlineProvider);
                    if(!editMode) {
                      final added = await myAirlineUldsController.airlineAddUld(al!, codeC.text, "AKE");
                      if (added != null) {
                        navigationService.popDialog(onPop: (){
                          SuccessHandler.handle(ServerSuccess(code: 1, msg: "Uld Added Successfully"));
                        });
                      }
                    }else{
                      final updated = TagContainer(id: widget.editingUld!.id, typeId: 1, code: codeC.text, positionID: 1, classTypeID: 1, title: '', ocrPrefix: [],);
                      final up = await myAirlineUldsController.airlineUpdateUld(updated);
                      if (up != null) {
                        navigationService.popDialog(onPop: (){
                          SuccessHandler.handle(ServerSuccess(code: 1, msg: "Uld ${widget.editingUld!.id} Updated Successfully"));
                        });
                      }
                    }
                  },
                  label: editMode?"Save":"Add",
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

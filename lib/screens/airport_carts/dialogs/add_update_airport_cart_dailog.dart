import 'dart:io';
import 'package:brs_panel/core/abstracts/success_abs.dart';
import 'package:brs_panel/core/classes/airport_cart_class.dart';
import 'package:brs_panel/core/util/handlers/success_handler.dart';
import 'package:brs_panel/screens/airport_carts/airport_carts_controller.dart';
import 'package:brs_panel/screens/airport_carts/airport_carts_state.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/MyButton.dart';

import '../../../../core/constants/ui.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../initialize.dart';

class AddUpdateAirportCartDialog extends StatefulWidget {
  final TagContainer? editingCart;

  const AddUpdateAirportCartDialog({Key? key, required this.editingCart}) : super(key: key);

  @override
  State<AddUpdateAirportCartDialog> createState() => _AddUpdateAirportCartDialogState();
}

class _AddUpdateAirportCartDialogState extends State<AddUpdateAirportCartDialog> {
  final AirportCartsController myAirportCartsController = getIt<AirportCartsController>();

  final NavigationService navigationService = getIt<NavigationService>();
  final TextEditingController codeC = TextEditingController();
  final TextEditingController barcodeC = TextEditingController();

  @override
  void initState() {
    if(widget.editingCart!=null){
      codeC.text = widget.editingCart!.code;
      barcodeC.text = widget.editingCart!.barcode;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;
    bool editMode = widget.editingCart != null;
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
              Text(editMode ? 'Update Airport Dialog' : "Add Airport Dialog", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
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
                    final al = myAirportCartsController.ref.read(selectedAirportProvider);
                    if(!editMode) {
                      final added = await myAirportCartsController.airportAddCart(codeC.text);
                      if (added != null) {
                        navigationService.popDialog(onPop: (){
                          SuccessHandler.handle(ServerSuccess(code: 1, msg: "Cart Added Successfully"));
                        });
                      }
                    }else{
                      final updated = TagContainer(id: widget.editingCart!.id, typeId: 1, code: codeC.text, title: '', positionId: null);
                      final up = await myAirportCartsController.airportUpdateCart(updated);
                      if (up != null) {
                        navigationService.popDialog(onPop: (){
                          SuccessHandler.handle(ServerSuccess(code: 1, msg: "Cart ${widget.editingCart!.id} Updated Successfully"));
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

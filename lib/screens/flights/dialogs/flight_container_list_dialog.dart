import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';

import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../flights_controller.dart';

class FlightContainerListDialog extends StatefulWidget {
  final List<TagContainer> allCons;
  final List<TagContainer> cons;

  const FlightContainerListDialog({Key? key,required this.cons,required this.allCons}) : super(key: key);

  @override
  State<FlightContainerListDialog> createState() => _FlightContainerListDialogState();
}

class _FlightContainerListDialogState extends State<FlightContainerListDialog> {
  final FlightsController myFlightsController = getIt<FlightsController>();

  final NavigationService navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;

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
          Container(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              direction: Axis.horizontal,
              children: widget.cons.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: MyColors.lineColor)
                  ),
                  child: Text(e.code))).toList(),
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              direction: Axis.horizontal,
              children: widget.cons.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: MyColors.lineColor)
                  ),
                  child: Text(e.code))).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: const Text("Add")),
                const Spacer(),
                MyButton(
                  onPressed: () => navigationService.popDialog(),
                  label: "Cancel",
                  color: MyColors.greyishBrown,
                ),
                const SizedBox(width:12),
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
    );
  }
}

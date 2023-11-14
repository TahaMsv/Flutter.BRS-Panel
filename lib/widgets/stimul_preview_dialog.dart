import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:window_manager/window_manager.dart';
import '../../../widgets/MyButton.dart';

import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../initialize.dart';

class StimulPreviewDialog extends StatefulWidget {
  final String url;

  StimulPreviewDialog({Key? key,required this.url}) : super(key: key);

  @override
  State<StimulPreviewDialog> createState() => _StimulPreviewDialogState();
}

class _StimulPreviewDialogState extends State<StimulPreviewDialog> {
  final NavigationService navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = Get.width;
    double height = Get.height;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 18),
              const Text("Stimul Preview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
            child:  Column(
              children: [

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                //TextButton(onPressed: () {}, child: const Text("Add")),
                const Spacer(),

                 MyButton(
                  onPressed: ()=>navigationService.popDialog(),
                  label: "Done",
                  color: MyColors.lightIshBlue,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/bsm/data_tables/bsm_data_table.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyButtonPanel.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/LoadingListView.dart';
import 'barcode_generator_controller.dart';
import 'barcode_generator_state.dart';

class BarcodeGeneratorViewPhone extends ConsumerWidget {
  const BarcodeGeneratorViewPhone({super.key});

  static final BarcodeGeneratorController myBgController = getIt<BarcodeGeneratorController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BarcodeGeneratorState state = ref.watch(bgProvider);
    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  height: 50,
                  width: 250,
                  label: "Start: ",
                  controller: state.startController,
                  // showClearButton: true,
                ),
                const SizedBox(width: 40),
                MyTextField(
                  height: 50,
                  width: 250,
                  label: "End: ",
                  controller: state.endController,
                  // showClearButton: true,
                ),
                const SizedBox(width: 40),
                MyButton(
                  height: 45,
                  width: 50,
                  label: 'Generate Barcodes',
                  fontSize: 12,
                  onPressed: myBgController.generateBarcodes,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (c, i) => state.barcodes[i],
                  itemCount: state.barcodes.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


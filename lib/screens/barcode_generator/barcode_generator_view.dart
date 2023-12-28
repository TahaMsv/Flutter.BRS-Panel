import 'package:brs_panel/core/constants/data_bases_keys.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/data_base/web_data_base.dart';
import '../../widgets/MyDropDown.dart';
import '../../widgets/MySwitchButton.dart';
import '../flight_details/flight_details_controller.dart';
import 'barcode_generator_controller.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'barcode_generator_state.dart';

class BarcodeGeneratorView extends ConsumerWidget {
  const BarcodeGeneratorView({super.key});

  static final BarcodeGeneratorController myBgController = getIt<BarcodeGeneratorController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BarcodeGeneratorState state = ref.watch(bgProvider);
    final FlightDetailsController flightDetailsController = getIt<FlightDetailsController>();

    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 170,
                  child: MyDropDown<String>(
                      label: "Barcode type",
                      items: BarcodeType.values.map((e) => e.name).toList(),
                      itemToString: (i) => i.toString(),
                      onSelect: (i) {
                        myBgController.changeBarcodeType(i!);
                        // SessionStorage().setString(SsKeys.barcodeType, i);
                      },
                      value: state.conf.type.name),
                ),
                const SizedBox(width: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.showRangeMode) MySwitchButton(value: state.isRangeMode, onChange: (v) => myBgController.toggleRangeMode(), label: "Range Mode"),
                    const SizedBox(width: 40),
                    MyTextField(
                      height: 50,
                      width: 250,
                      label: state.isRangeMode ? "Start: " : "Barcode: ",
                      inputFormatters: [state.conf.getBarcodeInputFormatterForTextInput(state.isRangeMode)],
                      controller: state.startController,
                      maxLength: state.conf.maxLength,
                      // onChanged: (v) => SessionStorage().setString(SsKeys.barcodeStartC, v),

                    ),
                    const SizedBox(width: 40),
                    if (state.showRangeMode && state.isRangeMode)
                      MyTextField(
                        height: 50,
                        width: 250,
                        label: "End: ",
                        inputFormatters: [state.conf.getBarcodeInputFormatterForTextInput(state.isRangeMode)],
                        controller: state.endController,
                        maxLength: state.conf.maxLength,
                        // onChanged: (v) => SessionStorage().setString(SsKeys.barcodeEndC, v),

                      ),
                    if (!state.showRangeMode || !state.isRangeMode) const SizedBox(width: 250),
                  ],
                ),
                const SizedBox(width: 40),
                MyButton(
                  height: 45,
                  label: 'Generate Barcodes',
                  fontSize: 12,
                  onPressed: myBgController.generateBarcodes,
                ),
                const SizedBox(width: 40),
                TextButton.icon(
                  onPressed: () {
                    myBgController.printBarcodesRange();
                  },
                  label: const Text("Print Barcodes"),
                  icon: const Icon(Icons.print_rounded),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (c, i) =>
                      SizedBox(
                        child: Column(
                          children: [
                            SizedBox(height: 100, width: 200, child: state.barcodes[i]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(state.barcodesValue[i]),
                                    TextButton.icon(
                                      onPressed: () {
                                        myBgController.printBarcode(i);
                                      },
                                      label: const Text(""),
                                      icon: const Icon(Icons.print_rounded),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  itemCount: state.barcodes.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 150,
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

import 'package:barcode_widget/barcode_widget.dart';
import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'barcode_generator_state.dart';

class BarcodeGeneratorController extends MainController {
  late BarcodeGeneratorState bgmState = ref.read(bgProvider);

  void generateBarcodes() {
    // print(bgmState.barcodes);
    bgmState.barcodes = [];
    int start = int.parse(bgmState.startController.text);
    int end = int.parse(bgmState.endController.text);
    if (start > end) {
      int temp = start;
      start = end;
      end = temp;
    }
    for (int i = start; i <= end; i++) {
      bgmState.barcodes.add(
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: '$i',
          width: 50,
          height: 50,
        ),
      );
    }
    // print(bgmState.barcodes);
    bgmState.setState();
  }
}

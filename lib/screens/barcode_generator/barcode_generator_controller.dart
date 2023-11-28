import 'package:barcode_widget/barcode_widget.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'barcode_generator_state.dart';

class BarcodeGeneratorController extends MainController {
  late BarcodeGeneratorState bgmState = ref.read(bgProvider);

  void toggleRangeMode() {
    bgmState.isRangeMode = !bgmState.isRangeMode;
    bgmState.setState();
  }

  void changeBarcodeType(String name) {
    bgmState.conf.type = bgmState.conf.getBarcodeTypeByName(name);
    bgmState.showRangeMode = getShowRangeMode(bgmState.conf.type);
    // bgmState.rangeMode = bgmState.conf.getBarcodeInputFormatter(bgmState.conf.type) == FilteringTextInputFormatter.digitsOnly;
    bgmState.setState();
  }

  void generateBarcodes() {
    String start = bgmState.startController.text;
    String end = bgmState.endController.text;
    if (bgmState.isRangeMode) {
      if (start.length < bgmState.conf.minLength) {
        FailureHandler.handle(ValidationFailure(
            code: 1, msg: 'Start length must be greater than ${bgmState.conf.minLength - 1} characters', traceMsg: ""));
        return;
      }
      if (!isValidBarcode(start)) {
        FailureHandler.handle(ValidationFailure(code: 1, msg: "Start: Invalid barcode", traceMsg: ""));
        return;
      }
      if (end.length < bgmState.conf.minLength) {
        FailureHandler.handle(ValidationFailure(
            code: 1, msg: 'End length must be greater than ${bgmState.conf.minLength - 1} characters', traceMsg: ""));
        return;
      }
      if (!isValidBarcode(end)) {
        FailureHandler.handle(ValidationFailure(code: 1, msg: "End: Invalid barcode", traceMsg: ""));
        return;
      }
    } else {
      if (start.length < bgmState.conf.minLength) {
        FailureHandler.handle(ValidationFailure(
            code: 1,
            msg: 'Barcode length must be greater than ${bgmState.conf.minLength - 1} characters',
            traceMsg: ""));
        return;
      }
      if (!isValidBarcode(start)) {
        FailureHandler.handle(ValidationFailure(code: 1, msg: "Barcode: Invalid barcode", traceMsg: ""));
        return;
      }
    }
    print(bgmState.conf.barcode);
    bgmState.barcodes = [];
    if (bgmState.showRangeMode && bgmState.isRangeMode) {
      int startInt = int.parse(start);
      int endInt = int.parse(end);

      if (startInt > endInt) {
        int temp = startInt;
        startInt = endInt;
        endInt = temp;

        String tempS = start;
        start = end;
        end = tempS;
      }

      for (int i = startInt; i <= endInt; i++) {
        bgmState.barcodes.add(
          BarcodeWidget(
            barcode: bgmState.conf.barcode,
            data: i.toString().padLeft(start.length, '0'),
            width: 50,
            height: 50,
          ),
        );
      }
    } else {
      bgmState.barcodes = [];
      String barcode = bgmState.startController.text;

      bgmState.barcodes.add(
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: barcode,
          width: 50,
          height: 50,
        ),
      );
    }
    // print(bgmState.barcodes);
    bgmState.setState();
  }

  bool getShowRangeMode(BarcodeType type) {
    switch (type) {
      case BarcodeType.CodeEAN5:
      case BarcodeType.CodeEAN2:
      case BarcodeType.Code39:
      case BarcodeType.Code93:
      case BarcodeType.Code128:
      case BarcodeType.GS128:
      case BarcodeType.Telepen:
      case BarcodeType.QrCode:
      case BarcodeType.Codabar:
      case BarcodeType.PDF417:
      case BarcodeType.DataMatrix:
      case BarcodeType.Aztec:
      case BarcodeType.Itf:
        return true;
      default:
        return false;
    }
  }

  bool isValidBarcode(String input) {
    try {
      String charSetString = String.fromCharCodes(bgmState.conf.barcode.charSet);
      // Escape special characters in the charSetString
      charSetString = RegExp.escape(charSetString);

      // Create a RegExp pattern from the charSetString
      String pattern = '^[$charSetString]*\$';

      // Create a RegExp instance
      RegExp regex = RegExp(pattern);

      // Test the input string against the regex
      return regex.hasMatch(input);
    } catch (e) {
      return false;
    }
  }
}

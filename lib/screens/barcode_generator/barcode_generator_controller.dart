import 'package:barcode_widget/barcode_widget.dart';
import 'package:brs_panel/core/constants/data_bases_keys.dart';
import 'package:flutter/material.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/data_base/web_data_base.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'barcode_generator_state.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BarcodeGeneratorController extends MainController {
  late BarcodeGeneratorState bgmState = ref.read(bgProvider);

  Future<void> retrieveBarcodeGenScreenFromLocalStorage() async {
    final String barcodeTypeString = await SessionStorage().getString(SsKeys.barcodeType) ?? BarcodeType.Code128.name;
    final bool isRangeMode = await SessionStorage().getBool(SsKeys.rangeMode) ?? false;
    final String startCString = await SessionStorage().getString(SsKeys.barcodeStartC) ?? '';
    final String savedDateTimeString = await SessionStorage().getString(SsKeys.barcodeEndC) ?? '';

    changeBarcodeType(barcodeTypeString);
    bgmState.isRangeMode = isRangeMode;
    bgmState.startController.text = startCString;
    bgmState.endController.text = savedDateTimeString;
    generateBarcodes(showError: false);
    bgmState.setState();
  }

  void toggleRangeMode()async {
    bgmState.isRangeMode = !bgmState.isRangeMode;
    await SessionStorage().setBool(SsKeys.rangeMode, bgmState.isRangeMode);
    bgmState.setState();
  }

  void changeBarcodeType(String name) {
    bgmState.conf.type = bgmState.conf.getBarcodeTypeByName(name);
    bgmState.showRangeMode = getShowRangeMode(bgmState.conf.type);
    // bgmState.rangeMode = bgmState.conf.getBarcodeInputFormatter(bgmState.conf.type) == FilteringTextInputFormatter.digitsOnly;
    bgmState.setState();
  }

  printBarcode(int i) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              height: 100,
              width: 200,
              child: pw.BarcodeWidget(
                data: bgmState.barcodesValue[i],
                barcode: bgmState.conf.barcode,
                textStyle: const pw.TextStyle(fontSize: 0),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(bgmState.barcodesValue[i])
          ],
        ),
      );
    }));
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save(),);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Future<void> printBarcodesRange() async {
    final doc = pw.Document();
    final barcodesPerPage = 20; // Number of barcodes per page
    final barcodesPerRow = 4; // Number of barcodes per page
    final totalPages = (bgmState.barcodes.length / barcodesPerPage).ceil();

    for (var page = 0; page < totalPages; page++) {
      final startIndex = page * barcodesPerPage;
      final endIndex = (startIndex + barcodesPerPage < bgmState.barcodes.length) ? startIndex + barcodesPerPage : bgmState.barcodes.length;

      doc.addPage(
        pw.Page(
          build: (pw.Context context) {
            final rows = <pw.Widget>[];

            for (var i = startIndex; i < endIndex; i += barcodesPerRow) {
              final rowChildren = <pw.Widget>[];
              final rowEndIndex = (i + barcodesPerRow < endIndex) ? i + barcodesPerRow : endIndex;

              for (var j = i; j < rowEndIndex; j++) {
                rowChildren.add(pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 15),
                    height: 50,
                    width: 100,
                    child: pw.BarcodeWidget(
                      data: bgmState.barcodesValue[j],
                      barcode: bgmState.conf.barcode,
                      textStyle: const pw.TextStyle(fontSize: 0),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(bgmState.barcodesValue[j])
                ]));
              }

              rows.add(pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 25),
                child: pw.Row(
                  children: rowChildren,
                ),
              ));
            }

            return pw.Column(
              children: rows,
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  void generateBarcodes({bool showError = true}) {
    String start = bgmState.startController.text;
    String end = bgmState.endController.text;
    if (bgmState.isRangeMode) {
      if (start.length < bgmState.conf.minLength) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: 'Start length must be from ${bgmState.conf.minLength} to ${bgmState.conf.maxLength} characters', traceMsg: ""));
        return;
      }
      if (!isValidBarcode(start)) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: "Start: Invalid barcode", traceMsg: ""));
        return;
      }
      if (end.length < bgmState.conf.minLength) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: 'End length must be from ${bgmState.conf.minLength} to ${bgmState.conf.maxLength} characters', traceMsg: ""));
        return;
      }
      if (!isValidBarcode(end)) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: "End: Invalid barcode", traceMsg: ""));
        return;
      }
    } else {
      if (start.length < bgmState.conf.minLength) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: 'Barcode length must be from ${bgmState.conf.minLength} to ${bgmState.conf.maxLength} characters', traceMsg: ""));
        return;
      }
      if (!isValidBarcode(start)) {
        if (showError) FailureHandler.handle(ValidationFailure(code: 1, msg: "Barcode: Invalid barcode", traceMsg: ""));
        return;
      }
    }

    print(bgmState.conf.barcode);
    bgmState.barcodes = [];
    bgmState.barcodesValue = [];
    try {
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
              style: const TextStyle(color: Colors.transparent, fontSize: 0),
            ),
          );
          bgmState.barcodesValue.add(i.toString().padLeft(start.length, '0'));
        }
      } else {
        bgmState.barcodes = [];
        bgmState.barcodesValue = [];
        String barcode = bgmState.startController.text;
        bgmState.barcodes.add(
          BarcodeWidget(
            barcode: bgmState.conf.barcode,
            data: barcode,
            width: 50,
            height: 50,
            style: const TextStyle(color: Colors.transparent, fontSize: 0),
          ),
        );
        bgmState.barcodesValue.add(barcode);
      }
    } on BarcodeException catch (e) {
      FailureHandler.handle(ValidationFailure(code: 1, msg: e.message, traceMsg: ""));
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
      // String charSetString = String.fromCharCodes(bgmState.conf.barcode.charSet);
      final charset = StringBuffer();
      for (var c in bgmState.conf.barcode.charSet) {
        if (c > 0x20) {
          charset.write('${String.fromCharCode(c)} ');
        } else {
          charset.write('0x${c.toRadixString(16)} ');
        }
      }

      String charSetString = '[$charset]';
      // Escape special characters in the charSetString
      charSetString = RegExp.escape(charSetString);

      // Create a RegExp pattern from the charSetString
      String pattern = '^[$charSetString]*\$';
      RegExp regex = RegExp(pattern);

      return bgmState.conf.normalizedData(input) == input && regex.hasMatch(input);
    } catch (e) {
      return false;
    }
  }
}

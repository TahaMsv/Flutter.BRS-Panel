import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Barcode configuration
class BarcodeConf extends ChangeNotifier {
  BarcodeConf([BarcodeType initialType = BarcodeType.Code128]) {
    type = initialType;
  }

  late Barcode _barcode;

  String normalizedData(String data) {
    if (barcode is BarcodeEan && barcode.name != 'UPC E') {
      // ignore: avoid_as
      final ean = barcode as BarcodeEan;
      return ean.normalize(data);
    }

    return data;
  }

  late BarcodeType _type;

  Barcode get barcode => _barcode;

  int get minLength => _minLength;

  int get maxLength => _maxLength;

  /// Barcode type
  BarcodeType get type => _type;

  String? _data;

  set data(String value) {
    _data = value;
    notifyListeners();
  }

  late int _minLength = 1;

  late int _maxLength = 1000;

  BarcodeType getBarcodeTypeByName(String name) {
    for (BarcodeType type in BarcodeType.values) {
      if (type.toString().split('.').last == name) {
        print(type);
        return type;
      }
    }
    throw Exception('Invalid barcode type name');
  }

  TextInputFormatter getBarcodeInputFormatter(BarcodeType type) {
    switch (type) {
      case BarcodeType.CodeITF16:
      case BarcodeType.CodeITF14:
      case BarcodeType.CodeEAN13:
      case BarcodeType.CodeEAN8:
      case BarcodeType.CodeEAN5:
      case BarcodeType.CodeEAN2:
      case BarcodeType.CodeISBN:
      case BarcodeType.CodeUPCA:
      case BarcodeType.CodeUPCE:
        // These barcode types only accept digits
        return FilteringTextInputFormatter.digitsOnly;
      case BarcodeType.Code39:
      case BarcodeType.Code93:
      case BarcodeType.GS128:
      case BarcodeType.Codabar:
        // These barcode types accept digits, upper case letters and some special characters
        return FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z \$%\*\+\-\.\/:]'));
      case BarcodeType.Rm4scc:
        return FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]'));
      case BarcodeType.QrCode:
      case BarcodeType.PDF417:
      case BarcodeType.DataMatrix:
      case BarcodeType.Aztec:
      case BarcodeType.Telepen:
      case BarcodeType.Code128:
        return FilteringTextInputFormatter.allow(RegExp('.*'));
      default:
        return FilteringTextInputFormatter.digitsOnly;
    }
  }

  TextInputFormatter getBarcodeInputFormatterForTextInput(bool isRangeMode) {
    if (isRangeMode) return FilteringTextInputFormatter.digitsOnly;
    switch (type) {
      case BarcodeType.QrCode:
      case BarcodeType.PDF417:
      case BarcodeType.DataMatrix:
      case BarcodeType.Aztec:
      case BarcodeType.Telepen:
      case BarcodeType.Code128:
        return FilteringTextInputFormatter.allow(RegExp('.*'));
    }

    final charset = StringBuffer();
    for (var c in barcode.charSet) {
      if (c > 0x20) {
        charset.write('${String.fromCharCode(c)} ');
      } else {
        charset.write('0x${c.toRadixString(16)} ');
      }
    }

    String pattern = '[$charset]';
    print(pattern);
    return FilteringTextInputFormatter.allow(RegExp(pattern));
  }

  set type(BarcodeType value) {
    _type = value;

    switch (_type) {
      case BarcodeType.Itf:
        _barcode = Barcode.itf(zeroPrepend: true);
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.CodeITF16:
        _barcode = Barcode.itf16();
        _minLength = 15;
        _maxLength = 16;
        break;
      case BarcodeType.CodeITF14:
        _barcode = Barcode.itf14();
        _minLength = 13;
        _maxLength = 14;
        break;
      case BarcodeType.CodeEAN13:
        _barcode = Barcode.ean13(drawEndChar: true);
        _minLength = 12;
        _maxLength = 13;
        break;
      case BarcodeType.CodeEAN8:
        _barcode = Barcode.ean8(drawSpacers: true);
        _minLength = 7;
        _maxLength = 8;
        break;
      case BarcodeType.CodeEAN5:
        _barcode = Barcode.ean5();
        _minLength = 5;
        _maxLength = 5;
        break;
      case BarcodeType.CodeEAN2:
        _barcode = Barcode.ean2();
        _minLength = 2;
        _maxLength = 2;
        break;
      case BarcodeType.CodeISBN:
        _barcode = Barcode.isbn(drawEndChar: true);
        _minLength = 12;
        _maxLength = 13;
        break;
      case BarcodeType.Code39:
        _barcode = Barcode.code39();
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.Code93:
        _barcode = Barcode.code93();
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.CodeUPCA:
        _barcode = Barcode.upcA();
        _minLength = 11;
        _maxLength = 12;
        break;
      case BarcodeType.CodeUPCE:
        _barcode = Barcode.upcE();
        _minLength = 6;
        _maxLength = 12;
        break;
      case BarcodeType.Code128:
        _barcode = Barcode.code128(escapes: true);
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.GS128:
        _barcode = Barcode.gs128(useCode128A: false, useCode128B: false);
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.Telepen:
        _barcode = Barcode.telepen();
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.QrCode:
        _barcode = Barcode.qrCode();
        _minLength = 1;
        _maxLength = 2953;
        break;
      case BarcodeType.Codabar:
        _barcode = Barcode.codabar();
        _minLength = 1;
        _maxLength = 1000;
        break;
      case BarcodeType.PDF417:
        _barcode = Barcode.pdf417();
        _minLength = 1;
        _maxLength = 990;
        break;
      case BarcodeType.DataMatrix:
        _barcode = Barcode.dataMatrix();
        _minLength = 1;
        _maxLength = 1559;
        break;
      case BarcodeType.Aztec:
        _barcode = Barcode.aztec();
        _minLength = 1;
        _maxLength = 2335;
        break;
      case BarcodeType.Rm4scc:
        _barcode = Barcode.rm4scc();
        _minLength = 1;
        _maxLength = 1000;
        break;
    }

    notifyListeners();
  }
}

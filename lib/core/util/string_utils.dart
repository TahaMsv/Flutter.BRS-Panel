import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

String getFormattedNumber(String? value) {
  return double.tryParse(value ?? "") == null
      ? value ?? ""
      : NumberFormat.decimalPattern().format(double.tryParse(value ?? ""));
}

extension Format on num? {
  String get formattedStr {
    return double.tryParse("${this ?? ""}") == null
        ? "${this ?? ""}"
        : NumberFormat.decimalPattern().format(double.tryParse("${this ?? ""}"));
  }

  String get str {
    return "${this ?? ""}";
  }
}

extension Parse on String? {
  int? get tryInt {
    return int.tryParse((this ?? "").replaceAll(",", ""));
  }

  double? get tryDouble {
    return double.tryParse((this ?? "").replaceAll(",", ""));
  }

  String? get formattedInt {
    return tryInt == null ? this : tryInt.formattedStr;
  }

  Duration? get tryDuration {
    if (this == null || !this!.contains(":")) {
      return null;
    } else {
      List<String> splitted = this!.split(":");
      if (splitted.any((element) => int.tryParse(element) == null)) {
        return null;
      } else {
        if (splitted.length == 2) {
          return Duration(hours: int.tryParse(splitted[0])!, minutes: int.tryParse(splitted[1])!);
        } else if (splitted.length == 3) {
          return Duration(
              hours: int.tryParse(splitted[0])!,
              minutes: int.tryParse(splitted[1])!,
              seconds: int.tryParse(splitted[2])!);
        } else {
          return null;
        }
      }
    }
  }

  DateTime? get tryDateTime {
    if (this == null) {
      return null;
    } else {
      if (DateTime.tryParse(this!) != null) {
        return DateTime.tryParse(this!)!;
      } else {
        RegExp reg1 = RegExp(r'(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)');
        RegExp reg2 = RegExp(r'(\d\d:\d\d:\d\d)');
        RegExp reg3 = RegExp(r'(\d\d\d\d-\d\d-\d\d)');
        RegExp reg4 = RegExp(r'(\d\d:\d\d)');

        if (reg1.hasMatch(this!)) {
          String a = reg1.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd HH:mm:ss").parse(a);
        } else if (reg2.hasMatch(this!)) {
          String a = reg2.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm:ss").parse(a);
        } else if (reg3.hasMatch(this!)) {
          String a = reg3.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd").parse(a);
        } else if (reg4.hasMatch(this!)) {
          String a = reg4.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm").parse(a);
        } else {
          return null;
        }

        // if(this!.contains(" ")){
        //   String datePart = this!.split(" ")[0];
        //   if(datePart.)
        // }
      }
    }
  }

  DateTime? get tryDateTimeUTC {
    if (this == null) {
      return null;
    } else {
      if (DateTime.tryParse(this!) != null) {
        // print("yyyy-MM-dd HH:mm:ss" + this!);
        return DateFormat("yyyy-MM-dd HH:mm:ss").parse("${DateTime.tryParse(this!)!}", true);
      } else {
        RegExp reg1 = RegExp(r'(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)');
        RegExp reg2 = RegExp(r'(\d\d:\d\d:\d\d)');
        RegExp reg3 = RegExp(r'(\d\d\d\d-\d\d-\d\d)');
        RegExp reg4 = RegExp(r'(\d\d:\d\d)');

        if (reg1.hasMatch(this!)) {
          String a = reg1.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd HH:mm:ss").parse(a, true);
        } else if (reg2.hasMatch(this!)) {
          String a = reg2.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm:ss").parse(a, true);
        } else if (reg3.hasMatch(this!)) {
          String a = reg3.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd").parse(a, true);
        } else if (reg4.hasMatch(this!)) {
          // print(this);
          String a = reg4.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm").parse(a, true);
        } else {
          return null;
        }

        // if(this!.contains(" ")){
        //   String datePart = this!.split(" ")[0];
        //   if(datePart.)
        // }
      }
    }
  }
}

extension ParseNum on dynamic {
  int? get tryInt {
    return int.tryParse((this?.toString() ?? "").replaceAll(",", ""));
  }

  double? get tryDouble {
    if (this is double) return this;
    return double.tryParse((this?.toString() ?? "").replaceAll(",", ""));
  }

  String? get formattedInt {
    return this.tryInt == null ? this : this.tryInt.formattedStr;
  }

  Duration? get tryDuration {
    if (this == null || !this!.contains(":")) {
      return null;
    } else {
      List<String> splitted = this!.split(":");
      if (splitted.any((element) => int.tryParse(element) == null)) {
        return null;
      } else {
        if (splitted.length == 2) {
          return Duration(hours: int.tryParse(splitted[0])!, minutes: int.tryParse(splitted[1])!);
        } else if (splitted.length == 3) {
          return Duration(
              hours: int.tryParse(splitted[0])!,
              minutes: int.tryParse(splitted[1])!,
              seconds: int.tryParse(splitted[2])!);
        } else {
          return null;
        }
      }
    }
  }

  DateTime? get tryDateTime {
    if (this == null) {
      return null;
    } else {
      if (DateTime.tryParse(this!) != null) {
        return DateTime.tryParse(this!)!;
      } else {
        RegExp reg1 = RegExp(r'(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)');
        RegExp reg2 = RegExp(r'(\d\d:\d\d:\d\d)');
        RegExp reg3 = RegExp(r'(\d\d\d\d-\d\d-\d\d)');
        RegExp reg4 = RegExp(r'(\d\d:\d\d)');

        if (reg1.hasMatch(this!)) {
          String a = reg1.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd HH:mm:ss").parse(a);
        } else if (reg2.hasMatch(this!)) {
          String a = reg2.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm:ss").parse(a);
        } else if (reg3.hasMatch(this!)) {
          String a = reg3.firstMatch(this!)!.group(1)!;
          return DateFormat("yyyy-MM-dd").parse(a);
        } else if (reg4.hasMatch(this!)) {
          String a = reg4.firstMatch(this!)!.group(1)!;
          return DateFormat("HH:mm").parse(a);
        } else {
          return null;
        }
      }
    }
  }
}

extension ParseSelf on double? {
  int? get tryInt {
    if (this == null) return null;
    return this!.floor();
  }

  double? get tryDouble {
    return this;
  }

  double? get sixFraction {
    if (this == null) return null;
    return double.parse(this!.toStringAsFixed(6));
  }

  double? get twoFraction {
    if (this == null) return null;
    String tenDigit = this!.toStringAsFixed(10);
    String twoDigitStr = tenDigit.substring(0, tenDigit.length - 8);
    // double rem = this!%0.01;
    // double val = this!-rem;
    return double.parse(twoDigitStr);
  }

  String? get twoFractionSTR {
    if (this == null) return null;
    String tenDigit = this!.toStringAsFixed(10);
    String twoDigitStr = tenDigit.substring(0, tenDigit.length - 8);
    return twoDigitStr;
  }
}

extension Fromat on DateTime? {
  String get formatddMMMEEE {
    return this == null ? "" : DateFormat("ddMMM, EEE").format(this!);
  }

  String get formatddMMM {
    return this == null ? "" : DateFormat("dd MMM").format(this!);
  }

  String get formathhmm {
    return this == null ? "" : DateFormat("HH:mm").format(this!);
  }

  String get formathhmmss {
    return this == null ? "" : DateFormat("HH:mm:ss").format(this!);
  }

  String get formatyyyyMMdd {
    return this == null ? "" : DateFormat("yyyy-MM-dd").format(this!);
  }
}

extension FromatStr on Duration? {
  String? get formatHHMMSS {
    if (this == null) return null;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(this!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this!.inSeconds.remainder(60));
    return "${twoDigits(this!.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String? get formatHHMM {
    if (this == null) return null;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(this!.inMinutes.remainder(60));
    // String twoDigitSeconds = twoDigits(this!.inSeconds.remainder(60));
    return "${twoDigits(this!.inHours)}:$twoDigitMinutes";
  }
}

extension Summation on Iterable<int?> {
  int get sum {
    int s = fold(0, (p, n) => p = p + (n ?? 0));
    return s;
  }

  int? get maximum {
    if (isEmpty) return null;
    int s = (toList() as List<int>).reduce(max);
    return s;
  }

  String? get base64 {
    if (any((element) => element == null)) return null;
    List<int> bytes = toList() as List<int>;
    // Map<String, dynamic> data = {"data": bytes};
    String base64 = base64Encode(bytes);
    return base64;
  }
}

extension SummationD on Iterable<double?> {
  double get sum {
    double s = fold(0, (p, n) => p = p + (n ?? 0));
    return s;
  }
}

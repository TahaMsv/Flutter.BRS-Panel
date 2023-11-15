import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bgProvider = ChangeNotifierProvider<BarcodeGeneratorState>((_) => BarcodeGeneratorState());

class BarcodeGeneratorState extends ChangeNotifier {
  void setState() => notifyListeners();
  }
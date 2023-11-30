import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/barcode_config.dart';

final bgProvider = ChangeNotifierProvider<BarcodeGeneratorState>((_) => BarcodeGeneratorState());

class BarcodeGeneratorState extends ChangeNotifier {
  void setState() => notifyListeners();

  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  List<Widget> barcodes = [];
  List<String> barcodesValue = [];
  final BarcodeConf conf = BarcodeConf();

  bool isRangeMode = true;
  bool showRangeMode = true;
}

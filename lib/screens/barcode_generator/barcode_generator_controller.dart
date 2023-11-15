import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'barcode_generator_state.dart';

class BarcodeGeneratorController extends MainController {
  late BarcodeGeneratorState bsmState = ref.read(bgProvider);
}

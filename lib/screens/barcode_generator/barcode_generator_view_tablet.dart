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

class BarcodeGeneratorViewTablet extends StatelessWidget {
  static final BarcodeGeneratorController myBgController = getIt<BarcodeGeneratorController>();

  const BarcodeGeneratorViewTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Text("data"));
  }
}


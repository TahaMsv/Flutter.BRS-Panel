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
import 'package:barcode_widget/barcode_widget.dart';


class BarcodeGeneratorView extends StatefulWidget {
  static final BarcodeGeneratorController myBgController = getIt<BarcodeGeneratorController>();


  const BarcodeGeneratorView({super.key});

  @override
  State<BarcodeGeneratorView> createState() => _BarcodeGeneratorViewState();
}

class _BarcodeGeneratorViewState extends State<BarcodeGeneratorView> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<Widget> _barcodes = [];

  void _generateBarcodes() {
    setState(() {
      print(_barcodes);
      _barcodes = [];
      int start = int.parse(_startController.text);
      int end = int.parse(_endController.text);
      if (start > end) {
        int temp = start;
        start = end;
        end = temp;
      }
      for (int i = start; i <= end; i++) {
        _barcodes.add(
          BarcodeWidget(
            barcode: Barcode.code128(),
            data: '$i',
            width: 50,
            height: 50,
          ),
        );
      }
      print(_barcodes);
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _startController,
              decoration: InputDecoration(labelText: 'Start'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _endController,
              decoration: InputDecoration(labelText: 'End'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: _generateBarcodes,
              child: Text('Generate Barcodes'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 700),
                child: ListView(
                  children: _barcodes,
                ),
              ),
            ),
          ],
        ),
      ),);
  }
}

class BarcodeGenerator extends StatefulWidget {
  @override
  _BarcodeGeneratorState createState() => _BarcodeGeneratorState();
}

class _BarcodeGeneratorState extends State<BarcodeGenerator> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<Widget> _barcodes = [];

  void _generateBarcodes() {
    setState(() {
      print(_barcodes);
      _barcodes = [];
      int start = int.parse(_startController.text);
      int end = int.parse(_endController.text);
      if (start > end) {
        int temp = start;
        start = end;
        end = temp;
      }
      for (int i = start; i <= end; i++) {
        _barcodes.add(
          BarcodeWidget(
            barcode: Barcode.code128(),
            data: '$i',
            width: 50,
            height: 50,
          ),
        );
      }
      print(_barcodes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _startController,
              decoration: InputDecoration(labelText: 'Start'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _endController,
              decoration: InputDecoration(labelText: 'End'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _generateBarcodes,
              child: Text('Generate Barcodes'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 700),
                child: ListView(
                  children: _barcodes,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


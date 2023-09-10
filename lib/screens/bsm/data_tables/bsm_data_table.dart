import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:brs_panel/core/abstracts/success_abs.dart';
import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:brs_panel/core/navigation/navigation_service.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/core/util/handlers/success_handler.dart';
import 'package:brs_panel/widgets/TagCountWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/classes/flight_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/AirlineLogo.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../bsm_controller.dart';

enum BsmDataTableColumn { id, msg, response, tagNumbers }

extension BsmDataTableColumnDetails on BsmDataTableColumn {
  double get width {
    switch (this) {
      case BsmDataTableColumn.id:
        return 0.1;
      case BsmDataTableColumn.msg:
        return 0.5;
      case BsmDataTableColumn.response:
        return 0.2;
      case BsmDataTableColumn.tagNumbers:
        return 0.2;
    }
  }
  String get label {
    switch (this) {
      case BsmDataTableColumn.id:
        return "Mesasge ID";
      case BsmDataTableColumn.msg:
        return "BSM Message";
      case BsmDataTableColumn.response:
        return "BSM Response";
      case BsmDataTableColumn.tagNumbers:
        return "#Tags";
    }
  }
}

class BsmDataSource extends DataGridSource {
  late final List<BsmResult> _dataList;
  late final BsmController bsmController = getIt<BsmController>();

  BsmDataSource({required List<BsmResult> bsm}) {
    _dataList = bsm;
    _bsm = bsm
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<int>(columnName: BsmDataTableColumn.id.name, value: e.messageId),
              DataGridCell<String>(columnName: BsmDataTableColumn.msg.name, value: e.messageBody),
              DataGridCell<String>(columnName: BsmDataTableColumn.response.name, value: e.bsmResultText),
              DataGridCell<String>(columnName: BsmDataTableColumn.tagNumbers.name, value: e.tagListStr),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _bsm = [];

  @override
  List<DataGridRow> get rows => _bsm;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final BsmResult bsm = _dataList[index];
    return DataGridRowAdapter(
        color: index.isEven ? MyColors.evenRow : MyColors.oddRow,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == BsmDataTableColumn.id.name) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(bsm.messageId.toString()),
            );
          }
          if (dataGridCell.columnName == BsmDataTableColumn.msg.name) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(bsm.messageBody),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignment: Alignment.bottomRight,
                  child: DotButton(
                    icon: Icons.file_copy,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: bsm.messageBody));
                      NavigationService ns = getIt<NavigationService>();
                      ns.snackbar(const Text("Message Copied to Clipboard"));
                      // SuccessHandler.handle(ServerSuccess(code: 1, msg: "Message Copied to Clipboard"));
                    },
                  ),
                ),
              ],
            );
          }
          if (dataGridCell.columnName == BsmDataTableColumn.response.name) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(bsm.bsmResultText),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignment: Alignment.bottomRight,
                  child: DotButton(
                    icon: Icons.file_copy,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: bsm.messageBody));
                      NavigationService ns = getIt<NavigationService>();
                      ns.snackbar(const Text("Message Copied to Clipboard"));
                      // SuccessHandler.handle(ServerSuccess(code: 1, msg: "Message Copied to Clipboard"));
                    },
                  ),
                ),
              ],
            );
          }
          if (dataGridCell.columnName == BsmDataTableColumn.tagNumbers.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: bsm.getTags.where((element) => element.isNotEmpty)
                    .map((e) => BarcodeWidget(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.only(bottom: 36,top: 12),
                      barcode: Barcode.itf(),
                      data: e,
                    ))
                    .toList(),
              ),
            );
          }
          return Container();
        }).toList());
  }
}

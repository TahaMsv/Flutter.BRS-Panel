import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/TagCountWidget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/classes/flight_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/AirlineLogo.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../bsm_controller.dart';

enum BsmDataTableColumn {
  id,
  msg,
  response,
}

extension BsmDataTableColumnDetails on BsmDataTableColumn {
  double get width {
    switch (this) {
      case BsmDataTableColumn.id:
        return 0.1;
      case BsmDataTableColumn.msg:
        return 0.6;
      case BsmDataTableColumn.response:
        return 0.3;
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
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [Text(bsm.messageId.toString())],
              ),
            );
          }
          if (dataGridCell.columnName == BsmDataTableColumn.msg.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(bsm.messageBody),
            );
          }
          if (dataGridCell.columnName == BsmDataTableColumn.response.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(bsm.bsmResultText),
            );
          }
          return Container();
        }).toList());
  }
}

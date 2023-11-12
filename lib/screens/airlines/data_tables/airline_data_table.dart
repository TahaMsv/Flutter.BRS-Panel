import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/TagCountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/classes/login_user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/AirlineLogo.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../airlines_controller.dart';

enum AirlineDataTableColumn {
  airline,
  name,
  actions,
}

extension AirlineDataTableColumnDetails on AirlineDataTableColumn {
  double get width {
    switch (this) {
      case AirlineDataTableColumn.airline:
        return 0.15;
      case AirlineDataTableColumn.name:
        return 0.15;
      case AirlineDataTableColumn.actions:
        return 0.7;
    }
  }
}

class AirlineDataSource extends DataGridSource {
  late final List<String> _dataList;
  late final AirlinesController airlinesController = getIt<AirlinesController>();

  AirlineDataSource({required List<String> airlines}) {
    _dataList = airlines;
    _airlines = airlines
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: AirlineDataTableColumn.airline.name, value: e),
              DataGridCell<String>(columnName: AirlineDataTableColumn.name.name, value: e),
              DataGridCell<String>(columnName: AirlineDataTableColumn.actions.name, value: ''),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _airlines = [];

  @override
  List<DataGridRow> get rows => _airlines;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final String f = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == AirlineDataTableColumn.airline.name) {
        return Row(
          children: [
            const SizedBox(width: 12),
            AirlineLogo(
              f,
              key: Key(f),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(f)),
            const SizedBox(width: 12),
          ],
        );
      }
      if (dataGridCell.columnName == AirlineDataTableColumn.name.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(f),
        );
      }
      if (dataGridCell.columnName == AirlineDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                height: 30,
                // fontSize: 12,
                label: "ULD List", fade: true, onPressed: () async{
                  await airlinesController.goUlds(f);
                },
              ),
              const SizedBox(width: 12),
              // DotButton(
              //   icon: Icons.more_vert,
              //   onPressed: () {
              //     // airlinesController.airlineActionDialog(f);
              //   },
              // )
            ],
          ),
        );
      }
      return Container();
    }).toList());
  }
}

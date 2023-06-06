import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/TagCountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/classes/user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../aircrafts_controller.dart';

enum AircraftDataTableColumn {
  register,
  al,
  actions,
}

extension AircraftDataTableColumnDetails on AircraftDataTableColumn {
  double get width {
    switch (this) {
      case AircraftDataTableColumn.register:
        return 0.15;
      case AircraftDataTableColumn.al:
        return 0.15;
      case AircraftDataTableColumn.actions:
        return 0.7;
    }
  }
}

class AircraftDataSource extends DataGridSource {
  late final List<Aircraft> _dataList;
  late final AircraftsController aircraftsController = getIt<AircraftsController>();

  AircraftDataSource({required List<Aircraft> aircrafts}) {
    _dataList = aircrafts;
    _aircrafts = aircrafts
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: AircraftDataTableColumn.register.name, value: e.registration),
              DataGridCell<String>(columnName: AircraftDataTableColumn.al.name, value: e.al),
              DataGridCell<String>(columnName: AircraftDataTableColumn.actions.name, value: ''),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _aircrafts = [];

  @override
  List<DataGridRow> get rows => _aircrafts;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final Aircraft f = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == AircraftDataTableColumn.register.name) {
        return Row(
          children: [
            const SizedBox(width: 12),
            Expanded(child: Text(f.registration)),
            const SizedBox(width: 12),
          ],
        );
      }
      if (dataGridCell.columnName == AircraftDataTableColumn.al.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(f.al),
        );
      }
      if (dataGridCell.columnName == AircraftDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // MyButton(
              //   height: 30,
              //   // fontSize: 12,
              //   label: "ULD List",fade: true,onPressed: (){
              //   aircraftsController.goUlds(f);
              // },),
              const SizedBox(width: 12),
              DotButton(
                icon: Icons.more_vert,
                onPressed: () {
                  // aircraftsController.aircraftActionDialog(f);
                },
              )
            ],
          ),
        );
      }
      return Container();
    }).toList());
  }
}

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
import '../airports_controller.dart';

enum AirportDataTableColumn {
  airport,
  name,
  actions,
}

extension AirportDataTableColumnDetails on AirportDataTableColumn {
  double get width {
    switch (this) {
      case AirportDataTableColumn.airport:
        return 0.15;
      case AirportDataTableColumn.name:
        return 0.15;
      case AirportDataTableColumn.actions:
        return 0.7;
    }
  }
}

class AirportDataSource extends DataGridSource {
  late final List<Airport> _dataList;
  late final AirportsController airportsController = getIt<AirportsController>();

  AirportDataSource({required List<Airport> airports}) {
    _dataList = airports;
    _airports = airports
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: AirportDataTableColumn.airport.name, value: e.code),
              DataGridCell<String>(columnName: AirportDataTableColumn.name.name, value: e.name),
              DataGridCell<String>(columnName: AirportDataTableColumn.actions.name, value: ''),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _airports = [];

  @override
  List<DataGridRow> get rows => _airports;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final Airport f = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == AirportDataTableColumn.airport.name) {
        return Row(
          children: [
            const SizedBox(width: 12),
            Expanded(child: Text(f.code)),
            const SizedBox(width: 12),
          ],
        );
      }
      if (dataGridCell.columnName == AirportDataTableColumn.name.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(f.name),
        );
      }
      if (dataGridCell.columnName == AirportDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // MyButton(
              //   height: 30,
              //   // fontSize: 12,
              //   label: "ULD List",fade: true,onPressed: (){
              //   // airportsController.goUlds(f);
              // },),
              const SizedBox(width: 12),
              DotButton(
                icon: Icons.more_vert,
                onPressed: () {
                  // airportsController.airportActionDialog(f);
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

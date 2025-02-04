import 'package:brs_panel/core/constants/ui.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/airport_class.dart';
import '../../../initialize.dart';
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
  late final List<DetailedAirport> _dataList;
  late final AirportsController airportsController = getIt<AirportsController>();

  AirportDataSource({required List<DetailedAirport> airports}) {
    _dataList = airports;
    _airports = airports
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: AirportDataTableColumn.airport.name, value: e.code),
              DataGridCell<String>(columnName: AirportDataTableColumn.name.name, value: e.code),
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
    final DetailedAirport a = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == AirportDataTableColumn.airport.name) {
        return Row(
          children: [
            const SizedBox(width: 12),
            Expanded(child: Text(a.code)),
            const SizedBox(width: 12),
          ],
        );
      }
      if (dataGridCell.columnName == AirportDataTableColumn.name.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(a.code),
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
              //   label: "Sections",
              //   fade: true,
              //   onPressed: () async => await airportsController.goSections(a),
              // ),
              const SizedBox(width: 12),
              MyButton(
                height: 30,
                // fontSize: 12,
                label: "Cart List",
                fade: true,
                onPressed: () async => await airportsController.goCarts(a),
              ),
              const SizedBox(width: 12),
              MyButton(
                onPressed: () async => await airportsController.goSetting(a),
                label: 'Setting',
                fade: true,
                height: 30,
                width: 35,
                child: const Icon(Icons.settings, size: 20),
              ),
              const SizedBox(width: 12),
              MyButton(
                onPressed: () async => await airportsController.openAddUpdateAirportDialog(airport: a),
                label: 'Edit',
                fade: true,
                height: 30,
                width: 35,
                child: const Icon(Icons.edit, size: 20),
              ),
              const SizedBox(width: 12),
              MyButton(
                onPressed: () async => await airportsController.deleteAirport(a),
                label: 'Delete',
                color: MyColors.red,
                fade: true,
                height: 30,
                width: 35,
                child: const Icon(Icons.delete_forever, size: 20),
              )
            ],
          ),
        );
      }
      return Container();
    }).toList());
  }
}

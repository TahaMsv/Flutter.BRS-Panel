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
import '../flights_controller.dart';

enum FlightDataTableColumn {
  flight,
  status,
  route,
  time,
  aircraft,
  register,

  actions,
}

extension FlightDataTableColumnDetails on FlightDataTableColumn {
  double get width {
    switch (this) {
      case FlightDataTableColumn.flight:
        return 0.15;
      case FlightDataTableColumn.status:
        return 0.41;
      case FlightDataTableColumn.route:
        return 0.08;
      case FlightDataTableColumn.time:
        return 0.08;
      case FlightDataTableColumn.aircraft:
        return 0.08;
      case FlightDataTableColumn.register:
        return 0.1;
      case FlightDataTableColumn.actions:
        return 0.1;
    }
  }
}

class FlightDataSource extends DataGridSource {
  late final List<Flight> _dataList;
  late final FlightsController flightsController = getIt<FlightsController>();

  FlightDataSource({required List<Flight> flights}) {
    _dataList = flights;
    _flights = flights
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: FlightDataTableColumn.flight.name, value: e.flightNumber),
              DataGridCell<int>(columnName: FlightDataTableColumn.status.name, value: 1),
              DataGridCell<String>(columnName: FlightDataTableColumn.route.name, value: e.from),
              DataGridCell<String>(columnName: FlightDataTableColumn.time.name, value: e.std),
              DataGridCell<int>(columnName: FlightDataTableColumn.aircraft.name, value: e.getAircraft?.id),
              DataGridCell<String>(columnName: FlightDataTableColumn.register.name, value: e.getAircraft?.registration),

              DataGridCell<String>(columnName: FlightDataTableColumn.actions.name, value: ''),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _flights = [];

  @override
  List<DataGridRow> get rows => _flights;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final Flight f = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == FlightDataTableColumn.flight.name) {
        return Row(
          children: [
            const SizedBox(width: 12),
            AirlineLogo(
              f.al,
              key: Key(f.al),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text("$f")),
            SizedBox(
              height: 15,
              width: 30,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: f.isTest ? MyColors.red : Colors.transparent),
                child: Text(
                  f.isTest ? "Test" : "",
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.route.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text('${f.from}-${f.to}'),
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.time.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(f.std),
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.aircraft.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text("${f.getAircraft?.id??'-'}"),
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.register.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Text(f.getAircraft?.registration??'-'),
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.status.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            children: [
              ...f.positions.map((p) {
                final pp = BasicClass.getPositionByID(p.id);
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TagCountWidget(position:p,color: pp!.getColor,)
                  );
              })
            ],
          ),
        );
      }
      if (dataGridCell.columnName == FlightDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                height: 30,
                // fontSize: 12,
                label: "Details",fade: true,onPressed: (){
                flightsController.goDetails(f);
              },),
              const SizedBox(width: 12),
              DotButton(
                icon: Icons.more_vert,
                onPressed: () {
                  // flightsController.flightActionDialog(f);
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

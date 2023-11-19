import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/widgets/TagCountWidget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/classes/flight_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/AirlineLogo.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../flights_controller.dart';
import '../flights_state.dart';

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
        return 0.13;
      case FlightDataTableColumn.status:
        return 0.43;
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
        color: index.isEven ? MyColors.evenRow : MyColors.oddRow,
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
              alignment: Alignment.centerLeft,
              child: Text('${f.from}-${f.to}'),
            );
          }
          if (dataGridCell.columnName == FlightDataTableColumn.time.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.std),
            );
          }
          if (dataGridCell.columnName == FlightDataTableColumn.aircraft.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text("${f.getAircraft?.id ?? '-'}"),
            );
          }
          if (dataGridCell.columnName == FlightDataTableColumn.register.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.getAircraft?.registration ?? '-'),
            );
          }
          if (dataGridCell.columnName == FlightDataTableColumn.status.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              // alignment: Alignment.center,
              child: Row(
                children: [
                  ...BasicClass.systemSetting.positions.map((p) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            flightsController.goDetails(f, selectedPos: p);
                          },
                          child: TagCountWidget(
                            position: p,
                            sections: f.positions.firstWhereOrNull((element) => element.id == p.id)?.sections ?? [],
                            color: p.getColor,
                            count: f.positions.firstWhereOrNull((element) => element.id == p.id)?.tagCount ?? 0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
                    label: "Details",
                    fade: true,
                    onPressed: () {
                      flightsController.goDetails(f);
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      items: [
                        ...MenuItems.firstItems.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: MenuItems.buildItem(item),
                          ),
                        ),
                        // const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                        // ...MenuItems.secondItems.map(
                        //   (item) => DropdownMenuItem<MenuItem>(
                        //     value: item,
                        //     child: MenuItems.buildItem(item),
                        //   ),
                        // ),
                      ],
                      onChanged: (value) async {
                        WidgetRef ref = getIt<WidgetRef>();
                        bool loading = ref.watch(flightActionHandlingProvider).contains(f.id);
                        if (loading) return;
                        ref.read(flightActionHandlingProvider.notifier).update((state) => (state + [f.id]).toSet().toList());
                        await flightsController.handleActions(value as MenuItem, f);
                        ref.read(flightActionHandlingProvider.notifier).update((state) => state.where((element) => element != f.id).toList());
                        // MenuItems.onChanged(navigator!.context, value! as MenuItem);
                      },
                      customButton: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          bool loading = ref.watch(flightActionHandlingProvider).contains(f.id);
                          if (loading) {
                            return DotButton(
                              icon: Icons.more_vert,
                              color: MyColors.mainColor,
                              child: Spinners.circle,
                            );
                          } else {
                            return const IgnorePointer(
                              child: DotButton(
                                icon: Icons.more_vert,
                                color: MyColors.mainColor,
                              ),
                            );
                          }
                        },
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: 160,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        offset: const Offset(0, 8),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.only(left: 4, right: 4),
                      ),
                    ),
                  ),
                  // DotButton(
                  //   icon: Icons.more_vert,
                  //   onPressed: () async {
                  //     await flightsController.editContainers(f);
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

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [
    flightSummary,
    assignContainer,
    // openWebView,
    containersPlan,
  ];

  static const flightSummary = MenuItem(text: 'Flight Summary', icon: Icons.home);
  static const assignContainer = MenuItem(text: 'Assign Container', icon: Icons.share);
  static const openWebView = MenuItem(text: 'Open WebView', icon: Icons.open_in_browser);
  static const containersPlan = MenuItem(text: 'Containers Plan', icon: Icons.queue_play_next);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.assignContainer:
        //Do something
        break;
      case MenuItems.flightSummary:
        //Do something
        break;
      case MenuItems.openWebView:
        break;
    }
  }
}

import 'package:brs_panel/core/platform/spiners.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/AirlineLogo.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../flights_controller.dart';
import '../flights_state.dart';

const List<String> staticFlightDataTableColumn = [
  "flight",
  "route",
  "std",
  "aircraft",
  "register",
  "actions",
];

List<String> flightDataTableColumn = [
  staticFlightDataTableColumn[0],
  "status",
  staticFlightDataTableColumn[1],
  staticFlightDataTableColumn[2],
  staticFlightDataTableColumn[3],
  staticFlightDataTableColumn[4],
  staticFlightDataTableColumn[5],
];

double getFlightDataTableColumnFlex(String flightData) {
  if (staticFlightDataTableColumn[0] == flightData) {
    return 0.13;
  } else if (staticFlightDataTableColumn[5] == flightData) {
    return 0.09;
  } else if (staticFlightDataTableColumn[4] == flightData) {
    return 0.09;
  } else if (staticFlightDataTableColumn[3] == flightData) {
    return 0.05;
  } else if (staticFlightDataTableColumn[2] == flightData) {
    return 0.05;
  } else if (staticFlightDataTableColumn[1] == flightData) {
    return 0.07;
  } else {
    int statusColumnCount = flightDataTableColumn.length - 6;
    return (0.52 / statusColumnCount);
  }
}

class FlightDataSource extends DataGridSource {
  late final List<Flight> _dataList;
  late final FlightsController flightsController = getIt<FlightsController>();

  FlightDataSource({required List<Flight> flights}) {
    _dataList = flights;
    flights.sort((a, b) => (a.terminal ?? "").compareTo(b.terminal ?? ""));
    List<String> terminals = [];
    for (var f in flights) {
      if (!terminals.contains(f.terminal ?? "")) terminals.add(f.terminal ?? "");
    }
    List<DataGridRow> rows = [];
    for (var t in terminals) {
      if(t.isNotEmpty) rows.add(DataGridRow(cells: flightDataTableColumn.map((e) => DataGridCell<String>(columnName: e, value: flightDataTableColumn.indexOf(e) == 5 ? t : "")).toList()));
      rows.addAll(flights.where((f) => (f.terminal ?? "") == t).map<DataGridRow>((f) => DataGridRow(cells: flightDataTableColumn.map((e) => DataGridCell<Flight>(columnName: e, value: f)).toList())));
    }
    _flights = rows;
    // _flights = flights.map<DataGridRow>((f) => DataGridRow(cells: flightDataTableColumn.map((e) => DataGridCell<Flight>(columnName: e, value: f)).toList())).toList();
  }

  List<DataGridRow> _flights = [];

  @override
  List<DataGridRow> get rows => _flights;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    List<DataGridCell> cells = row.getCells();
    if (cells.any((c) => c.value is String)) {
      return DataGridRowAdapter(color: Colors.black, cells: cells.map((c) => Center(child: Text(c.value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))).toList());
    }
    final int index = rows.indexOf(row);
    final Flight f = cells.first.value;
    return DataGridRowAdapter(
        color: index.isEven ? MyColors.evenRow4 : MyColors.oddRow,
        cells: cells.map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == staticFlightDataTableColumn[0]) {
            return Row(
              children: [
                const SizedBox(width: 12),
                AirlineLogo(f.al, key: Key(f.al)),
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
          } else if (dataGridCell.columnName == staticFlightDataTableColumn[1]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text('${f.from}-${f.to}'),
            );
          } else if (dataGridCell.columnName == staticFlightDataTableColumn[2]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.std),
            );
          } else if (dataGridCell.columnName == staticFlightDataTableColumn[3]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text("${f.getAircraft?.id ?? '-'}"),
            );
          } else if (dataGridCell.columnName == staticFlightDataTableColumn[4]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.getAircraft?.registration ?? '-'),
            );
          } else if (dataGridCell.columnName == staticFlightDataTableColumn[5]) {
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
          } else {
            List<PositionSection> sections = f.positions.firstWhereOrNull((p) => p.title == dataGridCell.columnName)?.sections ?? [];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: sections.map((s) => SectionCountElement(name: s.title, count: s.count, color: s.getColor)).toList(),
            );
          }
        }).toList());
  }
}

class SectionCountElement extends StatelessWidget {
  const SectionCountElement({super.key, required this.name, required this.count, required this.color});

  final String name;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      width: 35,
      margin: EdgeInsets.zero,
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.white), color: color),
      child: Text(
        "$count",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
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
    containersPlan,
    flightReport,
    reports,
  ];

  static const flightSummary = MenuItem(text: 'Flight Summary', icon: Icons.home);
  static const assignContainer = MenuItem(text: 'Assign Container', icon: Icons.share);
  static const containersPlan = MenuItem(text: 'Containers Plan', icon: Icons.queue_play_next);
  static const flightReport = MenuItem(text: 'Flight Report', icon: Icons.text_snippet_outlined);
  static const reports = MenuItem(text: 'Stimul Reports', icon: Icons.open_in_browser);

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
      case MenuItems.reports:
        break;
    }
  }
}

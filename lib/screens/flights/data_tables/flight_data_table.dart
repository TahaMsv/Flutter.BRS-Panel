import 'package:brs_panel/core/classes/login_user_class.dart';
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

const List<String> staticFlightDataTableColumn = [
  "flight",
  "route",
  "std",
  "aircraft",
  "register",
  "actions",
];

List<String> flightDataTableColumn = [
  "flight",
  "status",
  "route",
  "std",
  "aircraft",
  "register",
  "actions",
];

double getFlightDataTableColumnFlex(String flightData) {
  if (flightDataTableColumn[0] == flightData) {
    return 0.11;
  } else if (flightDataTableColumn[flightDataTableColumn.length - 1] == flightData) {
    return 0.09;
  } else if (flightDataTableColumn[flightDataTableColumn.length - 2] == flightData) {
    return 0.07;
  } else if (flightDataTableColumn[flightDataTableColumn.length - 3] == flightData) {
    return 0.06;
  } else if (flightDataTableColumn[flightDataTableColumn.length - 4] == flightData) {
    return 0.04;
  } else if (flightDataTableColumn[flightDataTableColumn.length - 5] == flightData) {
    return 0.06;
  } else {
    int statusColumnCount = flightDataTableColumn.length - 6;
    return (0.57 / statusColumnCount);
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
            cells: flightDataTableColumn.map((e) => DataGridCell<String>(columnName: e, value: e)).toList(),
            // [
            //   DataGridCell<String>(columnName: flightDataTableColumn[0], value: e.flightNumber),
            //   DataGridCell<int>(columnName: flightDataTableColumn, value: 1),
            //   DataGridCell<int>(columnName: flightDataTableColumn, value: 1),
            //   DataGridCell<int>(columnName: flightDataTableColumn, value: 1),
            //   DataGridCell<String>(columnName: flightDataTableColumn.route.name, value: e.from),
            //   DataGridCell<String>(columnName: flightDataTableColumn.std.name, value: e.std),
            //   DataGridCell<int>(columnName: flightDataTableColumn.aircraft.name, value: e.getAircraft?.id),
            //   DataGridCell<String>(columnName: flightDataTableColumn.register.name, value: e.getAircraft?.registration),
            //   DataGridCell<String>(columnName: flightDataTableColumn.actions.name, value: ''),
            // ],
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

    List<PositionSection> sections = [];
    for (var p in f.positions) {
      sections = sections + p.sections;
    }
    print(sections);

    return DataGridRowAdapter(
        color: index.isEven ? MyColors.evenRow : MyColors.oddRow,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == flightDataTableColumn[0]) {
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
          } else if (dataGridCell.columnName == flightDataTableColumn[flightDataTableColumn.length - 5]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text('${f.from}-${f.to}'),
            );
          } else if (dataGridCell.columnName == flightDataTableColumn[flightDataTableColumn.length - 4]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.std),
            );
          } else if (dataGridCell.columnName == flightDataTableColumn[flightDataTableColumn.length - 3]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text("${f.getAircraft?.id ?? '-'}"),
            );
          } else if (dataGridCell.columnName == flightDataTableColumn[flightDataTableColumn.length - 2]) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(f.getAircraft?.registration ?? '-'),
            );
          } else if (dataGridCell.columnName == flightDataTableColumn[flightDataTableColumn.length - 1]) {
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
            int count = sections.firstWhereOrNull((s) => s.title == dataGridCell.columnName)?.count ?? 0;
            Color color = sections.firstWhereOrNull((s) => s.title == dataGridCell.columnName)?.getColor ?? MyColors.mainColor;
            return Center(
              child: Container(
                height: 25,
                width: 25,
                margin:  EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.white),
                  color: color,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            );
          }
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

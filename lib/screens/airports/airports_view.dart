import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyTextField.dart';
import 'airports_controller.dart';
import 'airports_state.dart';
import 'data_tables/airport_data_table.dart';

class AirportsView extends StatelessWidget {
  const AirportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            AirportsPanel(),
            AirportListWidget(),
          ],
        ));
  }
}

class AirportsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();

  const AirportsPanel({Key? key}) : super(key: key);
  static AirportsController myAirportsController = getIt<AirportsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here...",
                controller: searchC,
                showClearButton: true,
                onChanged: (v) {
                  final s = ref.read(airportsSearchProvider.notifier);
                  s.state = v;
                },
              )),
          const SizedBox(width: 12),
          const Expanded(
            flex: 5,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class AirportListWidget extends ConsumerWidget {
  const AirportListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AirportsState state = ref.watch(airportsProvider);
    final airportList = ref.watch(filteredAirportListProvider);
    return Expanded(
      child: LoadingListView(
        loading: false,
        child: SfDataGrid(
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.none,
            sortingGestureType: SortingGestureType.doubleTap,
            allowSorting: true,
            headerRowHeight: 35,
            source: AirportDataSource(airports: airportList),
            columns: AirportDataTableColumn.values
                .map(
                  (e) => GridColumn(
                    columnName: e.name,
                    label: Center(child: Text(e.name.capitalizeFirst!)),
                    width: e.width * width,
                  ),
                )
                .toList()),
      ),
    );
  }
}

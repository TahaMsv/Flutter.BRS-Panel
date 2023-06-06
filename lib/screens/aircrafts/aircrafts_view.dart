import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/LoadingListView.dart';
import 'aircrafts_controller.dart';
import 'aircrafts_state.dart';
import 'data_tables/aircraft_data_table.dart';

class AircraftsView extends StatelessWidget {
  const AircraftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [AircraftListWidget()],
        ));
  }
}

class AircraftListWidget extends ConsumerWidget {
  const AircraftListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AircraftsState state = ref.watch(aircraftsProvider);
    final aircraftList = ref.watch(filteredAircraftListProvider);
    return Expanded(
      child: LoadingListView(
        loading: false,
        child: SfDataGrid(
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.none,
            sortingGestureType: SortingGestureType.doubleTap,
            allowSorting: true,
            headerRowHeight: 35,
            source: AircraftDataSource(aircrafts: aircraftList),
            columns: AircraftDataTableColumn.values
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

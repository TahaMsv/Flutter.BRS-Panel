import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/LoadingListView.dart';
import '../airlines/airlines_state.dart';
import 'airlines_controller.dart';
import 'airlines_state.dart';
import 'data_tables/airline_data_table.dart';

class AirlinesView extends StatelessWidget {
  const AirlinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            AirlineListWidget()
          ],
        ));
  }
}

class AirlineListWidget extends ConsumerWidget {
  const AirlineListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AirlinesState state = ref.watch(airlinesProvider);
    final airlineList = ref.watch(filteredAirlineListProvider);
    return Expanded(
      child: LoadingListView(
        loading: false,
        child: SfDataGrid(
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.none,
            sortingGestureType: SortingGestureType.doubleTap,
            allowSorting: true,
            headerRowHeight: 35,
            source: AirlineDataSource(airlines: airlineList),
            columns: AirlineDataTableColumn.values
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

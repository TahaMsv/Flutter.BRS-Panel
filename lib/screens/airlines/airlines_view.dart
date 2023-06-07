import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyTextField.dart';
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
            AirlinesPanel(),
            AirlineListWidget()
          ],
        ));
  }
}



class AirlinesPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();

  const AirlinesPanel({Key? key}) : super(key: key);
  static AirlinesController myAirlinesController = getIt<AirlinesController>();

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
                  final s = ref.read(airlineSearchProvider.notifier);
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

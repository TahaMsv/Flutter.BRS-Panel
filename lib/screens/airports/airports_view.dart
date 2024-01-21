import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
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

class AirportsPanel extends ConsumerStatefulWidget {
  const AirportsPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AirportsPanelState();
}

class _AirportsPanelState extends ConsumerState<AirportsPanel> {
  static TextEditingController searchC = TextEditingController();
  static AirportsController myAirportsController = getIt<AirportsController>();
  bool showClearButton = false;

  @override
  void initState() {
    showClearButton = searchC.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          DotButton(size: 35, onPressed: myAirportsController.openAddUpdateAirportDialog, icon: Icons.add, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here ...",
                controller: searchC,
                showClearButton: showClearButton,
                onChanged: (v) {
                  final s = ref.read(airportsSearchProvider.notifier);
                  s.state = v;
                  setState(() {
                    showClearButton = searchC.text.isNotEmpty;
                  });
                },
              )),
          const Expanded(flex: 5, child: SizedBox()),
          DotButton(icon: Icons.refresh, onPressed: () async => myAirportsController.getAirports()),
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
        loading: state.loading,
        child: SfDataGrid(
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.none,
            sortingGestureType: SortingGestureType.tap,
            allowSorting: true,
            headerRowHeight: 35,
            source: AirportDataSource(airports: airportList),
            columns: AirportDataTableColumn.values
                .map(
                  (e) => GridColumn(
                    columnName: e.name,
                    label: Center(child: Text(e.name.capitalizeFirst!)),
                    width: e.width * width,
                    allowSorting: e.name.capitalizeFirst! != "Actions",
                  ),
                )
                .toList()),
      ),
    );
  }
}

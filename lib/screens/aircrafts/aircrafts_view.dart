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
          children: [AircraftsPanel(), AircraftListWidget()],
        ));
  }
}

class AircraftsPanel extends ConsumerStatefulWidget {
  const AircraftsPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AircraftsPanelState();
}

class _AircraftsPanelState extends ConsumerState<AircraftsPanel> {
  static TextEditingController searchC = TextEditingController();
  static AircraftsController myAirlinesController = getIt<AircraftsController>();
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
          DotButton(
              size: 35,
              // onPressed: () => myAirlinesController.goAddAircraft(),
              onPressed: () => myAirlinesController.openAddUpdateAirCraftDialog(),
              icon: Icons.add,
              color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here ...",
                controller: searchC,
                showClearButton: showClearButton,                onChanged: (v) {
                  final s = ref.read(aircraftSearchProvider.notifier);
                  s.state = v;
                  setState(() {
                    showClearButton = searchC.text.isNotEmpty;
                  });
                },
              )),
          const Expanded(flex: 5, child: SizedBox()),
          DotButton(icon: Icons.refresh, onPressed: () async => myAirlinesController.getAircrafts()),
        ],
      ),
    );
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
        loading: state.loading,
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

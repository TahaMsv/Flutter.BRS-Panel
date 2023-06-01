import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/constants/ui.dart';
import '../../core/enums/flight_type_filter_enum.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyAnimatedSwitcher.dart';
import '../../widgets/MySegment.dart';
import '../../widgets/MyTextField.dart';
import 'data_tables/flight_data_table.dart';
import 'flights_controller.dart';
import 'flights_state.dart';

class FlightsView extends StatelessWidget {
  static FlightsController myFlightsController = getIt<FlightsController>();

  const FlightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            FlightsPanel(),
            FlightListWidget(),
          ],
        ));
  }
}

class FlightsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();
  static FlightsController myFlightsController = getIt<FlightsController>();

  const FlightsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showFilter = ref.watch(flightsShowFiltersProvider);
    FlightTypeFilter flightTypeFilter = ref.watch(flightTypeFilterProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          DotButton(
            size: 35,
            onPressed: () {
              myFlightsController.goAddFlight();
            },
            icon: Icons.add,
            color: Colors.blueAccent,
          ),
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
                  final s = ref.read(flightSearchProvider.notifier);
                  s.state = v;
                },
              )),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final dt = ref.watch(flightDateProvider);
                  final dtP = ref.read(flightDateProvider.notifier);
                  return ArtemisButtonPanel(
                    size: 35,
                    leftWidget: const Icon(Icons.chevron_left, size: 20, color: MyColors.black3),
                    rightWidget: const Icon(Icons.chevron_right, size: 20, color: MyColors.black3),
                    centerWidget: Text(
                      dt.toddMMMEEE,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black3,
                      ),
                    ),
                    leftAction: () => myFlightsController.flightList(dt.add(const Duration(days: -1))),
                    rightAction: () => myFlightsController.flightList(dt.add(const Duration(days: 1))),
                    centerAction: () {},
                  );
                },
              )),
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
              flex: 2,
              child: MyAnimatedSwitcher(
                // direction: Axis.horizontal,
                // axisAlignment: -2,
                value: showFilter,
                firstChild: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: MySegment<FlightTypeFilter>(
                          itemToString: (e) => e.toStr,
                          items: FlightTypeFilter.values,
                          onChange: (FlightTypeFilter v) {
                            ref.read(flightTypeFilterProvider.notifier).state = v;
                          },
                          value: flightTypeFilter,
                        )),
                    const SizedBox(width: 12),
                  ],
                ),
                secondChild: const SizedBox(),
              )),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.filter_alt_rounded,
            color: showFilter ? MyColors.lightIshBlue : Colors.black54,
            onPressed: () {
              ref.read(flightsShowFiltersProvider.notifier).state = !showFilter;
            },
          ),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.refresh,
            onPressed: () {
              FlightsController flightsController = getIt<FlightsController>();
              flightsController.flightList(ref.read(flightDateProvider));
            },
          ),
        ],
      ),
    );
  }
}

class FlightListWidget extends ConsumerWidget {
  const FlightListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final FlightsState state = ref.watch(flightsProvider);
    final flightList = ref.watch(filteredFlightListProvider);
    return Expanded(
      child: LoadingListView(
        loading: state.loadingFlights,
        child: SfDataGrid(
            headerGridLinesVisibility: GridLinesVisibility.both,
            selectionMode: SelectionMode.none,
            sortingGestureType: SortingGestureType.doubleTap,
            allowSorting: true,
            headerRowHeight: 35,
            source: FlightDataSource(flights: flightList),
            columns: FlightDataTableColumn.values
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

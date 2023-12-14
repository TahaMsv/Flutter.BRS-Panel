import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/ui.dart';
import '../../core/enums/flight_type_filter_enum.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyAnimatedSwitcher.dart';
import '../../widgets/MyFieldPicker.dart';
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
      body: Column(children: [
        FlightsPanel(),
        FlightListWidget(),
      ]),
    );
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
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          DotButton(size: 35, onPressed: () => myFlightsController.goAddFlight(), icon: Icons.add, color: Colors.blueAccent),
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
                  return ArtemisButtonPanel(
                    size: 35,
                    leftWidget: const Icon(Icons.chevron_left, size: 20, color: MyColors.black3),
                    rightWidget: const Icon(Icons.chevron_right, size: 20, color: MyColors.black3),
                    centerWidget: Text(dt.toddMMMEEE, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: MyColors.black3)),
                    leftAction: () => myFlightsController.flightList(dt.add(const Duration(days: -1))),
                    rightAction: () => myFlightsController.flightList(dt.add(const Duration(days: 1))),
                    centerAction: myFlightsController.pickDate,
                  );
                },
              )),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 5,
            child: MyAnimatedSwitcher(
              padding: const EdgeInsets.symmetric(vertical: 4),
              value: showFilter,
              firstChild: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        final a = ref.watch(flightAirportFilterProvider.notifier);
                        return SizedBox(
                          height: 35,
                          child: MyFieldPicker<Airport>(
                            itemToString: (a) => "${a.code} (${a.code})",
                            label: 'Airport',
                            items: BasicClass.systemSetting.airportList,
                            onChange: (v) => a.state = v,
                            value: a.state,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        final a = ref.watch(flightAirlineFilterProvider.notifier);
                        return SizedBox(
                          height: 35,
                          child: MyFieldPicker<String>(
                            itemToString: (a) => a,
                            label: 'Airline',
                            items: BasicClass.airlineList,
                            onChange: (v) => a.state = v,
                            value: a.state,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: MySegment<FlightTypeFilter>(
                      height: 35,
                      itemToString: (e) => e.toStr,
                      items: FlightTypeFilter.values,
                      onChange: (FlightTypeFilter v) => ref.read(flightTypeFilterProvider.notifier).state = v,
                      value: flightTypeFilter,
                    ),
                  ),
                ],
              ),
              secondChild: const SizedBox(height: 35),
            ),
          ),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.filter_alt_rounded,
            color: showFilter ? MyColors.lightIshBlue : Colors.black54,
            onPressed: () => ref.read(flightsShowFiltersProvider.notifier).state = !showFilter,
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
            shrinkWrapColumns: true,
            sortingGestureType: SortingGestureType.doubleTap,
            gridLinesVisibility: GridLinesVisibility.vertical,
            allowSorting: true,
            headerRowHeight: 35,
            source: FlightDataSource(flights: flightList),
            columns: FlightDataTableColumn.values
                .map((e) => GridColumn(
                      columnName: e.name,
                      label: Center(child: Text(e.label)),
                      width: e.width * width,
                      allowSorting: e.name.capitalizeFirst! != "Actions" && e.name.capitalizeFirst! != "Status",
                    ))
                .toList()),
      ),
    );
  }
}

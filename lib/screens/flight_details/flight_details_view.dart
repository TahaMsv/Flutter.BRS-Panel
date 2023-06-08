import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DetailsChart.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/basic_class.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';

class FlightDetailsView extends StatefulWidget {
  final int flightID;

  const FlightDetailsView({super.key, required this.flightID});

  @override
  State<FlightDetailsView> createState() => _FlightDetailsViewState();
}

class _FlightDetailsViewState extends State<FlightDetailsView> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => getIt<FlightDetailsController>().flightGetDetails(widget.flightID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            FlightDetailsWidget(),
          ],
        ));
  }
}

class FlightDetailsWidget extends ConsumerWidget {
  const FlightDetailsWidget({Key? key}) : super(key: key);
  static FlightDetailsController myFlightDetailsController = getIt<FlightDetailsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    final fdP = ref.watch(detailsProvider);
    final posListP = ref.watch(selectedFlightProvider);
    List<Position> posList = BasicClass.systemSetting.positions.where((pos) =>posListP!.positions.map((e) => e.id).contains(pos.id)).toList();
    return Expanded(
      child: Container(
        child: fdP.when(
          data: (d) => d == null
              ? const Text("No Data Found")
              : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DetailsWidget(
                        details: d,
                        posList: posList,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: DetailsChart(
                          details: d,
                          posList: posList,
                        ),
                      ),
                    ),
                  ],
                ),
          error: (e, __) => Text("$e"),
          loading: () => Spinners.spinner1,
        ),
      ),
    );
  }
}

class DetailsWidget extends StatefulWidget {
  final List<Position> posList;
  final FlightDetails details;

  const DetailsWidget({Key? key, required this.details, required this.posList}) : super(key: key);

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> with SingleTickerProviderStateMixin {
  late TabController controller;
  late List<Position> posList;

  @override
  void initState() {
    // posList = BasicClass.systemSetting.positions.where((pos) => widget.details.tagList.any((element) => element.currentPosition == pos.id)).toList();
    posList = widget.posList;
    controller = TabController(
      length: posList.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
              controller: controller,
              tabs: posList
                  .map((e) => TextButton(
                      onPressed: () {
                        controller.animateTo(posList.indexOf(e));
                      },
                      child: Text(e.title)))
                  .toList()),
        ),
        Expanded(
          child: TabBarView(
              controller: controller,
              children: posList
                  .map((e) => PositionDetailsWidget(
                        tags: widget.details.tagList
                            .where(
                              (element) => element.currentPosition == e.id,
                            )
                            .toList(),
                        pos: e,
                      ))
                  .toList()),
        ),
      ],
    );
  }
}

class PositionDetailsWidget extends StatelessWidget {
  final Position pos;
  final List<FlightTag> tags;

  const PositionDetailsWidget({Key? key, required this.tags, required this.pos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemBuilder: (c, i) => TagWidget(
        tag: tags[i],
        index: i,
      ),
      itemCount: tags.length,
    );
  }
}

class TagWidget extends StatelessWidget {
  final FlightTag tag;
  final int index;

  const TagWidget({Key? key, required this.tag, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      tileColor: index.isEven ? MyColors.white1 : Colors.white,
      title: Text(tag.numString),
      leading: Text(tag.secString),
      dense: true,
    );
  }
}

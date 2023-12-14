import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:brs_panel/core/constants/assest.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyExpansionTile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_summary_class.dart';
import '../../core/constants/ui.dart';
import '../../core/platform/spiners.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyTextField.dart';
import 'flight_summary_controller.dart';
import 'flight_summary_state.dart';

class FlightSummaryView extends StatelessWidget {
  final int flightID;

  const FlightSummaryView({super.key, required this.flightID});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            FlightDetailsPanel(),
            FlightSummaryWidget(),
          ],
        ));
  }
}

class FlightDetailsPanel extends ConsumerStatefulWidget {
  const FlightDetailsPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlightDetailsPanelState();
}

class _FlightDetailsPanelState extends ConsumerState<FlightDetailsPanel> {
  static FlightSummaryController myFlightSummaryController = getIt<FlightSummaryController>();
  static TextEditingController searchC = TextEditingController();
  bool showClearButton = false;

  @override
  void initState() {
    showClearButton = searchC.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Flight? f = ref.watch(selectedFlightProvider);
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox(width: 12)),
          FlightBanner(flight: f!),
          // Expanded(
          //     flex: 1,
          //     child: MyTextField(
          //       height: 35,
          //       prefixIcon: const Icon(Icons.search),
          //       placeholder: "Search Here ...",
          //       controller: searchC,
          // showClearButton: showClearButton,
          //       onChanged: (v) {
          //         // final s = ref.read(tagSearchProvider.notifier);
          //         // s.state = v;
          // setState(() {
          //   showClearButton = searchC.text.isNotEmpty;
          // });
          //       },
          //     )),
          const SizedBox(width: 12),

          DotButton(
            icon: Icons.history,
            onPressed: () async {
              await myFlightSummaryController.flightShowHistoryLogs();
            },
          ),
          const SizedBox(width: 12),
          DotButton(
            icon: Icons.refresh,
            onPressed: () async {
              final sfp = ref.read(selectedFlightProvider);
              final fdP = ref.read(flightSummaryProvider);
              ref.refresh(flightSummaryProvider);
              // FlightsController flightsController = getIt<FlightsController>();
              // flightsController.flightList(ref.read(flightDateProvider));
            },
          ),
        ],
      ),
    );
  }
}

class FlightSummaryWidget extends ConsumerWidget {
  const FlightSummaryWidget({Key? key}) : super(key: key);
  static FlightSummaryController myFlightSummaryController = getIt<FlightSummaryController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    final fsP = ref.watch(flightSummaryProvider);
    const TextStyle tileHeaderStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Expanded(
      child: Container(
        child: fsP.when(
          skipLoadingOnRefresh: false,
          data: (d) => d == null
              ? const Text("No Data Found")
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      MyExpansionTile(
                        headerTileColor: MyColors.oddRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Missed Tags", style: tileHeaderStyle)),
                              CountWidget(count: d.missedTagList.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.missedTagList
                            .map((e) => MissedTagWidget(
                                  missedTag: e,
                                  index: d.missedTagList.indexOf(e),
                                  isLast: d.missedTagList.last.tagNumber == e.tagNumber,
                                ))
                            .toList(),
                      ),
                      MyExpansionTile(
                        headerTileColor: MyColors.evenRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Exception Tags", style: tileHeaderStyle)),
                              CountWidget(count: d.exceptionTagList.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.exceptionTagList
                            .map((e) => ExceptionTagWidget(
                                  eTag: e,
                                  index: d.exceptionTagList.indexOf(e),
                                  isLast: d.exceptionTagList.last.tagId == e.tagId,
                                ))
                            .toList(),
                      ),
                      MyExpansionTile(
                        headerTileColor: MyColors.oddRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Forced Tags", style: tileHeaderStyle)),
                              CountWidget(count: d.forcedTagList.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.forcedTagList
                            .map((e) => ForcedTagWidget(
                                  forcedTag: e,
                                  index: d.forcedTagList.indexOf(e),
                                  isLast: d.forcedTagList.last.tagNumber == e.tagNumber,
                                ))
                            .toList(),
                      ),
                      MyExpansionTile(
                        headerTileColor: MyColors.evenRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Positions", style: tileHeaderStyle)),
                              CountWidget(count: d.positionSummaryList.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.positionSummaryList
                            .map((e) => PositionSummaryWidget(
                                  pos: e,
                                  index: d.positionSummaryList.indexOf(e),
                                  isLast: d.positionSummaryList.last.id == e.id,
                                ))
                            .toList(),
                      ),
                      MyExpansionTile(
                        headerTileColor: MyColors.oddRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Bins", style: tileHeaderStyle)),
                              CountWidget(count: d.binSummaryList.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.binSummaryList
                            .map((e) => BinSummaryWidget(
                                  bin: e,
                                  index: d.binSummaryList.indexOf(e),
                                  isLast: d.binSummaryList.last.bin == e.bin,
                                ))
                            .toList(),
                      ),
                      MyExpansionTile(
                        headerTileColor: MyColors.evenRow,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Deleted Tags", style: tileHeaderStyle)),
                              CountWidget(count: d.deletedTags.length),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        children: d.deletedTags
                            .map(
                              (e) => DeletedTagWidget(
                                deletedTag: e,
                                index: d.deletedTags.indexOf(e),
                                isLast: d.deletedTags.last.tagNumber == e.tagNumber,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
          error: (e, __) {
            print((e as Error).stackTrace);
            return Text("$e");
          },
          loading: () => Spinners.spinner1,
        ),
      ),
    );
  }
}

class MissedTagWidget extends StatelessWidget {
  final MissedTag missedTag;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const MissedTagWidget({Key? key, required this.missedTag, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Tag Number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Position",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    const Expanded(flex: 5, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Icon(Icons.circle, color: BasicClass.getPositionByID(missedTag.positionId)!.getColor, size: 8),
                        ),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              missedTag.tagNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getPositionByID(missedTag.positionId)!.title,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(missedTag.dateTimeUtc.tryDateTime).format_HHmmss,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(missedTag.username),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 5, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ExceptionTagWidget extends StatelessWidget {
  final FlightTag eTag;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const ExceptionTagWidget({Key? key, required this.eTag, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Tag Number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Position",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Status", style: headerTextStyle))),
                    const Expanded(flex: 4, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Icon(Icons.circle, color: BasicClass.getPositionByID(eTag.currentPosition)!.getColor, size: 8),
                        ),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              eTag.tagNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getPositionByID(eTag.currentPosition)!.title,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(eTag.tagPositions.first.dateUtc).format_HHmmss,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(eTag.tagPositions.first.username),
                  ),
                ),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      eTag.exception?.title ?? '-',
                      style: TextStyle(color: eTag.exception?.getColor),
                    ),
                  ),
                ),
                const Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ForcedTagWidget extends StatelessWidget {
  final ForcedTagList forcedTag;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const ForcedTagWidget({Key? key, required this.forcedTag, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Tag Number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Position",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Status", style: headerTextStyle))),
                    const Expanded(flex: 4, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Icon(Icons.circle, color: BasicClass.getPositionByID(forcedTag.positionId)!.getColor, size: 8),
                        ),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              forcedTag.tagNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getPositionByID(forcedTag.positionId)!.title,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(forcedTag.dateTimeUtc.tryDateTime).format_HHmmss,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(forcedTag.username),
                  ),
                ),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      forcedTag.ignoredErrorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PositionSummaryWidget extends StatelessWidget {
  final PositionSummaryList pos;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const PositionSummaryWidget({Key? key, required this.pos, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Position",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Tag Count",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("First Tag Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Last Tag Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    const Expanded(flex: 4, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Icon(Icons.circle, color: BasicClass.getPositionByID(pos.id)!.getColor, size: 8),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                            height: 40,
                            child: Icon(
                              pos.iconData,
                              color: BasicClass.getPositionByID(pos.id)!.getColor,
                            )),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              pos.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: Text("${pos.tagCount}"))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(pos.firstTagTimeUtc.tryDateTime).format_HHmmss,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      BasicClass.getTimeFromUTC(pos.lastTagTimeUtc.tryDateTime).format_HHmmss,
                    ),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BinSummaryWidget extends StatelessWidget {
  final BinSummaryList bin;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const BinSummaryWidget({Key? key, required this.bin, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Bin",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Tag Count",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Weight", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Container Count", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    const Expanded(flex: 4, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        const SizedBox(width: 12),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              bin.bin,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: Text("${bin.tagCount}"))),
                const VerticalDivider(width: 24),
                Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: Text("${bin.totalWeight}"))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("${bin.hasULD ? bin.uldCount : '-'}"),
                        const SizedBox(width: 12),
                        bin.hasULD
                            ? Image.asset(
                                AssetImages.uld,
                                width: 30,
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DeletedTagWidget extends StatelessWidget {
  final DeletedTag deletedTag;
  final int index;
  final bool isLast;
  final void Function()? onTap;

  const DeletedTagWidget({Key? key, required this.deletedTag, required this.index, this.onTap, required this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isOdd = index % 2 != 0;
    const TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, color: MyColors.black, fontSize: 14);

    return Column(
      children: [
        index == 0
            ? Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isOdd ? MyColors.white2 : MyColors.white3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 2, height: 40, color: MyColors.containerGreen),
                            const SizedBox(width: 48),
                            Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Tag Number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                    const VerticalDivider(width: 24),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Position",
                              style: headerTextStyle,
                            ))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
                    const VerticalDivider(width: 24),
                    const Expanded(flex: 4, child: SizedBox())
                  ],
                ),
              )
            : const SizedBox(),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: !isOdd ? MyColors.white2 : MyColors.white3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2, height: isLast ? 20 : 40, color: MyColors.containerGreen),
                        Container(
                          width: 40,
                          height: 2,
                          color: MyColors.containerGreen,
                          margin: const EdgeInsets.only(top: 19),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Icon(Icons.circle, color: BasicClass.getPositionByID(deletedTag.positionId)!.getColor, size: 8),
                        ),
                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              deletedTag.tagNumber!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getPositionByID(deletedTag.positionId)!.title,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(deletedTag.dateTimeUtc).format_HHmmss,
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(deletedTag.username ?? '-'),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CountWidget extends StatelessWidget {
  final int count;

  const CountWidget({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
      child: Center(child: Text('$count')),
    );
  }
}

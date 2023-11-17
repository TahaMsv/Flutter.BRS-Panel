import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/history_log_class.dart';
import 'package:flutter/material.dart';
import '../../../core/util/basic_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../widgets/MyExpansionTile.dart';

class FlightHistoryLogDialog extends StatelessWidget {
  final HistoryLog logs;
  final NavigationService navigationService = getIt<NavigationService>();
  FlightHistoryLogDialog({Key? key,required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    const TextStyle tileHeaderStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 18),
              const Text("Flight History Log", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    navigationService.popDialog();
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(height: 1),
          Container(
            height: MediaQuery.of(context).size.height*0.7,
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyExpansionTile(
                    headerTileColor: MyColors.oddRow,
                    title: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("Flight Logs", style: tileHeaderStyle),
                    ),
                    children: logs.flightLogs
                        .map((e) => FlightLogWidget(
                      log: e,
                      index:  logs.flightLogs.indexOf(e),
                    ))
                        .toList(),
                  ),
                  MyExpansionTile(
                    headerTileColor: MyColors.evenRow,
                    title: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("Tag Logs", style: tileHeaderStyle),
                    ),
                    children: logs.tagLogs
                        .map((e) => TagLogWidget(
                      log: e,
                      index:  logs.tagLogs.indexOf(e),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                //TextButton(onPressed: () {}, child: const Text("Add")),
                const Spacer(),
                 MyButton(
                   onPressed: ()=>navigationService.popDialog(),
                  label: "Done",
                  color: theme.primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class FlightLogWidget extends StatelessWidget {
  final Log log;
  final int index;
  final void Function()? onTap;

  const FlightLogWidget({Key? key, required this.log, required this.index, this.onTap}) : super(key: key);

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
                  child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Action Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              const VerticalDivider(width: 24),
              Expanded(
                flex: 3,
                  child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Description",
                        style: headerTextStyle,
                      ))),
              const VerticalDivider(width: 24),
              Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
              const VerticalDivider(width: 24),
              Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
              const VerticalDivider(width: 24),
              const Expanded(flex: 3, child: SizedBox())
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

                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              log.actionType,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                  flex: 3,
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          log.description
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(log.dateUtc)?.format_HHmmss??'',
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(log.userName),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 3, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class TagLogWidget extends StatelessWidget {
  final Log log;
  final int index;
  final void Function()? onTap;

  const TagLogWidget({Key? key, required this.log, required this.index, this.onTap}) : super(key: key);

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
                  child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Action Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              const VerticalDivider(width: 24),
              Expanded(
                flex: 3,
                  child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Description",
                        style: headerTextStyle,
                      ))),
              const VerticalDivider(width: 24),
              Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("Time", style: headerTextStyle))),
              const VerticalDivider(width: 24),
              Expanded(child: Container(height: 40, alignment: Alignment.centerLeft, child: const Text("User", style: headerTextStyle))),
              const VerticalDivider(width: 24),
              const Expanded(flex: 3, child: SizedBox())
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

                        const SizedBox(width: 12),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              log.actionType,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const VerticalDivider(width: 24),
                Expanded(
                  flex: 3,
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          log.description
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          BasicClass.getTimeFromUTC(log.dateUtc)?.format_HHmmss??'',
                        ))),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(log.userName),
                  ),
                ),
                const VerticalDivider(width: 24),
                const Expanded(flex: 3, child: SizedBox())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
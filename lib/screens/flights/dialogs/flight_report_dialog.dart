import 'dart:convert';
import 'dart:math';

import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/containers_plan_class.dart';
import 'package:brs_panel/core/classes/flight_report_class.dart';
import 'package:brs_panel/core/constants/assest.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/screens/flights/data_tables/assigned_containers_data_table.dart';
import 'package:brs_panel/screens/flights/data_tables/available_containers_data_table.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/FlightBanner.dart';
import 'package:brs_panel/widgets/MyCheckBoxButton.dart';
import 'package:brs_panel/widgets/MySwitchButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../flight_details/flight_details_controller.dart';
import '../flights_controller.dart';

class FlightReportDialog extends StatefulWidget {
  final FlightReport flightReport;
  final Flight flight;

  const FlightReportDialog({Key? key, required this.flightReport, required this.flight}) : super(key: key);

  @override
  State<FlightReportDialog> createState() => _FlightReportDialogState();
}

class _FlightReportDialogState extends State<FlightReportDialog> {
  final FlightsController myFlightsController = getIt<FlightsController>();
  final NavigationService navigationService = getIt<NavigationService>();
  TextEditingController emailC = TextEditingController();
  TextEditingController typebC = TextEditingController();
  bool attachment = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    const TextStyle headerStyles = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    TextStyle reportStyle = GoogleFonts.inconsolata(fontSize: 15);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.3, vertical: 100),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        color: Colors.white,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        SizedBox(width: 18),
                        Text("Flight Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(width: 12),
                        Spacer(),
                      ],
                    )),
                IconButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const Divider(height: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlightBanner(flight: widget.flight),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(widget.flightReport.reportText.replaceAll(String.fromCharCode(13), "\n"), style: reportStyle),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.withOpacity(0.3),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text("Email")),
                      const SizedBox(width: 12),
                      Expanded(
                          flex: 7,
                          child: MyTextField(
                            placeholder: "a.b@c.com, a2.b@c.com, ",
                            controller: emailC,
                            onChanged: (String value) {
                              setState(() {});
                            },
                          )),
                      // const SizedBox(width: 12),
                      // DotButton(
                      //     icon: Icons.send,
                      //     color: Colors.green,
                      //     onPressed: () async {
                      //       await getIt<FlightsController>().flightSendReport(email: emailC.text, typeB: "", flight: widget.flight,attachment:attachment);
                      //     },
                      //     size: 40)
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: Text("Type B")),
                      const SizedBox(width: 12),
                      Expanded(
                          flex: 7,
                          child: MyTextField(
                            placeholder: "abcdefg, igklmno,",
                            controller: typebC,
                            onChanged: (String value) {
                              setState(() {});
                            },
                          )),
                      // const SizedBox(width: 12),
                      // DotButton(
                      //     icon: Icons.send,
                      //     color: Colors.green,
                      //     onPressed: () async {
                      //       await getIt<FlightsController>().flightSendReport(email: "", typeB: typebC.text, flight: widget.flight,attachment:attachment);
                      //     },
                      //     size: 40)
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 12),
              child: Row(
                children: [
                  MySwitchButton(
                      value: attachment,
                      onChange: (v) {
                        attachment = v;
                        setState(() {});
                      },
                      label: "Attachment"),
                  const Spacer(),
                  MyButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    label: "Cancel",
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  MyButton(
                    onPressed: emailC.text.trim().isEmpty && typebC.text.trim().isEmpty
                        ? null
                        : () async {
                            await getIt<FlightsController>().flightSendReport(email: emailC.text, typeB: typebC.text, flight: widget.flight, attachment: attachment);
                          },
                    label: "Send",
                    color: theme.primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:brs_panel/core/enums/week_days_enum.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyDropDown.dart';
import 'package:brs_panel/widgets/MyFieldPicker.dart';
import 'package:brs_panel/widgets/MySegment.dart';
import 'package:brs_panel/widgets/MySwitchButton.dart';
import 'package:brs_panel/widgets/MyTImeField.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/MyButtonPanel.dart';
import 'add_flight_controller.dart';
import 'add_flight_state.dart';

class AddFlightView extends StatefulWidget {
  static AddFlightController addFlightController = getIt<AddFlightController>();

  const AddFlightView({super.key});

  @override
  State<AddFlightView> createState() => _AddFlightViewState();
}

class _AddFlightViewState extends State<AddFlightView> {
  bool isSchedule = false;
  static AddFlightController myAddFlightController = getIt<AddFlightController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            const AddFlightPanel(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: AddFlightFLNBWidget()),
                      SizedBox(width: 24),
                      Expanded(child: AddFlightAirlineWidget()),
                      SizedBox(width: 24),
                      Expanded(child: AddFlightFromWidget()),
                      SizedBox(width: 24),
                      Expanded(child: AddFlightToWidget()),
                      SizedBox(width: 24),
                      Expanded(child: AddFlightAircraftWidget()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex:1,child: AddFlightDateWidget()),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            AddFlightState state = ref.watch(addFlightProvider);
                        
                            return state.isSchedule
                                ? Row(
                                    children: [
                                      // const Expanded(
                                      //   child: Row(
                                      //     mainAxisAlignment:MainAxisAlignment.end,
                                      //     children: [
                                      //       Text("To Date"),
                                      //       SizedBox(width: 12),
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(
                                        flex: 2,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            MyButtonPanel(
                                              size: 48,
                                              leftWidget: const Icon(Icons.chevron_left, size: 20, color: MyColors.black3),
                                              rightWidget: const Icon(Icons.chevron_right, size: 20, color: MyColors.black3),
                                              centerWidget: Text(
                                                state.toDate.format_ddMMMEEE,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: MyColors.black3,
                                                ),
                                              ),
                                              leftAction: () => myAddFlightController.setToDate(-1),
                                              rightAction: () => myAddFlightController.setToDate(1),
                                              centerAction: () => myAddFlightController.setToDate(null),
                                            ),
                                            state.isSchedule?const Text("To Date",style: TextStyle(fontSize: 10),):SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                  children: [
                                    Expanded(child: AddFlightSTDWidget()),
                                    SizedBox(width: 24),
                                    Expanded(child: AddFlightSTAWidget()),
                                    
                                  ],
                                );
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     children: [
                      //       const Expanded(child: AddFlightSTDWidget()),
                      //       const SizedBox(width: 24),
                      //       const Expanded(child: AddFlightSTAWidget()),
                      //       const SizedBox(width: 24),
                      //     ],
                      //   ),
                      // ),

                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Consumer(
                                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                    AddFlightState state = ref.watch(addFlightProvider);
                                    return Row(
                                      children: [
                                        const SizedBox(width: 24),
                                        MySwitchButton(
                                            value: state.isTest,
                                            onChange: (v) {
                                              state.isTest = v;
                                              state.setState();
                                            },
                                            label: 'Is Test'),
                                        const SizedBox(width: 24),
                                        MySwitchButton(
                                            value: state.isSchedule,
                                            onChange: (v) {
                                              state.isSchedule = v;
                                              state.setState();
                                            },
                                            label: "Schedule"),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 24),
                      const SizedBox(width: 24),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            AddFlightState state = ref.watch(addFlightProvider);
                            return Visibility(
                              visible: state.isSchedule,
                              child: const AddFlightToDateWidget(),
                            );
                          },
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const SizedBox(width: 24),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class AddFlightFLNBWidget extends StatelessWidget {
  const AddFlightFLNBWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return Row(
          children: [
            Expanded(
              child: MyTextField(
                height: 50,
                label: "Flight Number",
                controller: state.flnbC,
              ),
            ),
          ],
        );
      },
    ));
  }
}

class AddFlightAirlineWidget extends StatelessWidget {
  const AddFlightAirlineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyFieldPicker<String>(
          hasSearch: true,
          items: BasicClass.airlineList,
          label: "Airline",
          itemToString: (e) => e,
          value: state.al,
          onChange: (e) {
            final afState = ref.read(addFlightProvider.notifier);
            afState.al = e;
            afState.setState();
          },
        );
        // return MyDropDown<Airline>(
        //   itemToString: (e)=>"${e.al}(${e.name})",
        //   items: BasicClass.systemSetting.airlineList,
        //   onSelect: (e) {
        //     final afState = ref.read(addFlightProvider.notifier);
        //     afState.al = e;
        //     afState.setState();
        //   },
        //   value: state.al,
        // );
      },
    );
  }
}

class AddFlightAircraftWidget extends StatelessWidget {
  const AddFlightAircraftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyFieldPicker<Aircraft>(
          hasSearch: true,
          items: BasicClass.systemSetting.aircraftList,
          label: "Aircraft",
          itemToString: (e) => "${e.al} - ${e.registration.trim()}",
          value: state.aircraft,
          onChange: (e) {
            final afState = ref.read(addFlightProvider.notifier);
            afState.aircraft = e;
            afState.setState();
          },
        );
        // return MyDropDown<Airline>(
        //   itemToString: (e)=>"${e.al}(${e.name})",
        //   items: BasicClass.systemSetting.airlineList,
        //   onSelect: (e) {
        //     final afState = ref.read(addFlightProvider.notifier);
        //     afState.al = e;
        //     afState.setState();
        //   },
        //   value: state.al,
        // );
      },
    );
  }
}

class AddFlightDateWidget extends StatelessWidget {
  static AddFlightController myAddFlightController = getIt<AddFlightController>();

  const AddFlightDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return Row(
          children: [
            // state.isSchedule
            //     ? const Expanded(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             Text("From Date"),
            //             SizedBox(width: 24),
            //           ],
            //         ),
            //       )
            //     : const SizedBox(),
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MyButtonPanel(
                    size: 48,
                    leftWidget: const Icon(Icons.chevron_left, size: 20, color: MyColors.black3),
                    rightWidget: const Icon(Icons.chevron_right, size: 20, color: MyColors.black3),
                    centerWidget: Text(
                      state.fromDate.format_ddMMMEEE,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: MyColors.black3,
                      ),
                    ),
                    leftAction: () => myAddFlightController.setFromDate(-1),
                    rightAction: () => myAddFlightController.setFromDate(1),
                    centerAction: () => myAddFlightController.setFromDate(null),
                  ),
                  state.isSchedule?const Text("From Date",style: TextStyle(fontSize: 10),):SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddFlightToDateWidget extends StatelessWidget {
  static AddFlightController myAddFlightController = getIt<AddFlightController>();

  const AddFlightToDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var days = WeekDays.values.map((e) => e.labelMini).toList();
    // var days = oldDays.sublist(1);
    // days.add(oldDays.first);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     const Expanded(
                  //       child: Row(
                  //         children: [
                  //           Text("To Date"),
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 3,
                  //       child: MyButtonPanel(
                  //         size: 48,
                  //         leftWidget: const Icon(Icons.chevron_left, size: 20, color: MyColors.black3),
                  //         rightWidget: const Icon(Icons.chevron_right, size: 20, color: MyColors.black3),
                  //         centerWidget: Text(
                  //           state.toDate.format_ddMMMEEE,
                  //           style: const TextStyle(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w600,
                  //             color: MyColors.black3,
                  //           ),
                  //         ),
                  //         leftAction: () => myAddFlightController.setToDate(-1),
                  //         rightAction: () => myAddFlightController.setToDate(1),
                  //         centerAction: () => myAddFlightController.setToDate(null),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ...days.map((e) {
                    int id = days.indexOf(e) + 1;
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, left: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              MySwitchButton(
                                  value: state.weekTimes.keys.contains("$id") || state.weekTimes.keys.contains("$id"),
                                  onChange: (v) {
                                    if (state.weekTimes.keys.contains("$id")) {
                                      state.weekTimes.remove("$id");
                                    } else {
                                      state.weekTimes.putIfAbsent("$id", () => [null,null]);
                                    }
                                    // if (state.weekTimesSTA.keys.contains("$id")) {
                                    //   state.weekTimesSTA.remove("$id");
                                    // } else {
                                    //   state.weekTimesSTA.putIfAbsent("$id", () => null);
                                    // }
                                    state.setState();
                                  },
                                  label: e),
                            ],
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: MyTimeField(
                              label: "STD",
                              locked: !state.weekTimes.keys.contains("$id"),
                              value: state.weekTimes["$id"]?[0].format_HHmm,
                              onChange: () => myAddFlightController.setDayStd(id),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ...days.map((e) {
                    int id = days.indexOf(e) + 1;
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, left: 8),
                      child: Row(

                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: MyTimeField(
                              label: "STA",
                              locked: !state.weekTimes.keys.contains("$id"),
                              value: state.weekTimes["$id"]?[1].format_HHmm,
                              onChange: () => myAddFlightController.setDaySta(id),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddFlightFromWidget extends StatelessWidget {
  const AddFlightFromWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyFieldPicker<Airport>(
          hasSearch: true,
          // locked: state.flightTypeID==0,
          items: BasicClass.systemSetting.airportList,
          label: "From",
          itemToString: (e) => "${e.code} - ${e.cityName}",
          value: state.from,
          onChange: (e) {
            final afState = ref.read(addFlightProvider.notifier);
            afState.from = e;
            afState.setState();
          },
        );
      },
    );
  }
}

class AddFlightToWidget extends StatelessWidget {
  const AddFlightToWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyFieldPicker<Airport>(
          hasSearch: true,
          // locked: state.flightTypeID==1,
          items: BasicClass.systemSetting.airportList,
          label: "To",
          itemToString: (e) => "${e.code} - ${e.cityName}",
          value: state.to,
          onChange: (e) {
            final afState = ref.read(addFlightProvider.notifier);
            afState.to = e;
            afState.setState();
          },
        );
      },
    );
  }
}

class AddFlightSTDWidget extends StatelessWidget {
  static AddFlightController addFlightController = getIt<AddFlightController>();

  const AddFlightSTDWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyTimeField(
          label: "STD",
          value: state.std?.format_HHmm,
          onChange: addFlightController.setSTD,
        );
      },
    );
  }
}

class AddFlightSTAWidget extends StatelessWidget {
  static AddFlightController addFlightController = getIt<AddFlightController>();

  const AddFlightSTAWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MyTimeField(
          label: "STA",
          value: state.sta?.format_HHmm,
          onChange: addFlightController.setSTA,
        );
      },
    );
  }
}

class AddFlightTypeWidget extends StatelessWidget {
  static AddFlightController addFlightController = getIt<AddFlightController>();

  const AddFlightTypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return MySegment<int>(
            height: 50,
            items: const [0, 1],
            itemToString: (e) => e == 0 ? "Departure" : "Arrival",
            onChange: (v) {
              if (v == 0) {
                state.from = BasicClass.getAirportByCode(BasicClass.userSetting.airport);
                state.to = null;
              } else {
                state.to = BasicClass.getAirportByCode(BasicClass.userSetting.airport);
                state.from = null;
              }
              state.flightTypeID = v;
              state.setState();
            },
            value: state.flightTypeID);
      },
    );
  }
}

class AddFlightPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();
  static AddFlightController myAddFlightController = getIt<AddFlightController>();

  const AddFlightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const Spacer(),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              AddFlightState state = ref.watch(addFlightProvider);
              return MyButton(
                label: "Add Flight",
                disabled: state.validateAddFlight,
                onPressed: AddFlightView.addFlightController.addFlight,
              );
            },
          )
        ],
      ),
    );
  }
}

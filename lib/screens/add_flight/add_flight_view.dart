import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:brs_panel/core/enums/week_days_enum.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyCheckBox.dart';
import 'package:brs_panel/widgets/MyFieldPicker.dart';
import 'package:brs_panel/widgets/MySegment.dart';
import 'package:brs_panel/widgets/MySwitchButton.dart';
import 'package:brs_panel/widgets/MyTImeField.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/MyAnimatedSwitcher.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AddFlightPanel(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: AddFlightStage(label: "Flight Dates", items: [
                            SizedBox(width: 250, height: 40, child: AddFlightDateWidget(isFromDate: true)),
                            SizedBox(width: 20),
                            SizedBox(width: 260, child: AddFlightSetScheduleWidget()),
                            SizedBox(width: 20),
                          ]),
                        ),
                        Expanded(
                          child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            AddFlightState state = ref.watch(addFlightProvider);
                            return MyAnimatedSwitcher(
                              value: state.isSchedule,
                              firstChild: const AddFlightStage(label: "End Date", items: [
                                SizedBox(width: 250, height: 40, child: AddFlightDateWidget(isFromDate: false)),
                                SizedBox(width: 300),
                              ]),
                              secondChild: const SizedBox(),
                              direction: Axis.horizontal,
                            );
                          }),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        List<WeekDays> days = WeekDays.values;
                        AddFlightState state = ref.watch(addFlightProvider);
                        return MyAnimatedSwitcher(
                          value: state.isSchedule,
                          firstChild: AddFlightStage(key: UniqueKey(), label: "Days", height: 100, items: <Widget>[
                            const AddFlightDayElementWidget(id: 0, label: "All", b: true, hasTime: false),
                            ...days
                                .map((e) => AddFlightDayElementWidget(id: e.index + 1, label: e.labelMini, b: true))
                                .toList()
                          ]),
                          secondChild: SizedBox(key: UniqueKey()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: AddFlightStage(label: "Flight Number", items: [
                            SizedBox(width: 180, height: 40, child: AddFlightFLNBWidget()),
                          ]),
                        ),
                        Expanded(
                          child: AddFlightStage(label: "Airline", items: [
                            const SizedBox(width: 180, height: 40, child: AddFlightAirlineWidget()),
                            const Spacer(),
                            Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              AddFlightState state = ref.watch(addFlightProvider);
                              return MySwitchButton(
                                  value: state.isTest,
                                  onChange: (v) {
                                    state.isTest = v;
                                    state.setState();
                                  },
                                  label: ' Test Flight');
                            }),
                            const SizedBox(width: 24),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const AddFlightStage(label: "Aircraft", items: [
                      SizedBox(width: 180, height: 40, child: AddFlightAirlineWidget()),
                      SizedBox(width: 8),
                      SizedBox(width: 300, height: 40, child: AddFlightAircraftWidget()),
                    ]),
                    const Row(
                      children: [
                        Expanded(
                          child: AddFlightStage(label: "Departure", items: [
                            SizedBox(width: 300, height: 40, child: AddFlightFromWidget()),
                          ]),
                        ),
                        Expanded(
                          child: AddFlightStage(label: "Arrival", items: [
                            SizedBox(width: 300, height: 40, child: AddFlightToWidget()),
                          ]),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: AddFlightStage(label: "STD", items: [
                            SizedBox(width: 150, height: 40, child: AddFlightSTDWidget()),
                          ]),
                        ),
                        Expanded(
                          child: AddFlightStage(label: "STA", items: [
                            SizedBox(width: 150, height: 40, child: AddFlightSTAWidget()),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class AddFlightStage extends StatelessWidget {
  const AddFlightStage({super.key, required this.label, required this.items, this.height = 70});

  final String label;
  final double height;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor2, width: 1)),
      child: Row(children: [
        Container(
            width: 150,
            height: height,
            color: MyColors.evenRow2,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: Text(label, style: const TextStyle(fontSize: 16))),
        const SizedBox(width: 16),
        ...items
      ]),
    );
  }
}

class AddFlightSetScheduleWidget extends StatelessWidget {
  const AddFlightSetScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 120;
    return Container(
      decoration: BoxDecoration(
          color: MyColors.evenRow2,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: MyColors.borderColor)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            AddFlightState state = ref.watch(addFlightProvider);
            return InkWell(
                onTap: !state.isSchedule
                    ? null
                    : () {
                        state.isSchedule = false;
                        state.setState();
                      },
                child: Container(
                    height: 32,
                    width: buttonSize,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: !state.isSchedule ? MyColors.lightIshBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Non Schedule",
                        style: TextStyle(
                            color: !state.isSchedule ? MyColors.white3 : MyColors.black,
                            fontWeight: !state.isSchedule ? FontWeight.bold : FontWeight.normal))));
          }),
          Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            AddFlightState state = ref.watch(addFlightProvider);
            return InkWell(
                onTap: state.isSchedule
                    ? null
                    : () {
                        state.isSchedule = true;
                        state.setState();
                      },
                child: Container(
                    height: 32,
                    width: buttonSize,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: state.isSchedule ? MyColors.lightIshBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Schedule",
                        style: TextStyle(
                            color: state.isSchedule ? MyColors.white3 : MyColors.black,
                            fontWeight: state.isSchedule ? FontWeight.bold : FontWeight.normal))));
          }),
        ],
      ),
    );
  }
}

class AddFlightFLNBWidget extends StatelessWidget {
  const AddFlightFLNBWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return Row(
          children: [
            Expanded(
              child: MyTextField(
                height: 50,
                label: "Flight Number",
                labelStyle: const TextStyle(color: MyColors.brownGrey8, fontSize: 14),
                controller: state.flnbC,
              ),
            ),
          ],
        );
      },
    );
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
  final bool isFromDate;

  const AddFlightDateWidget({Key? key, required this.isFromDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        AddFlightState state = ref.watch(addFlightProvider);
        return Row(
          children: [
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
                      !isFromDate ? state.toDate.format_ddMMMEEE : state.fromDate.format_ddMMMEEE,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: MyColors.black3),
                    ),
                    leftAction: () =>
                        !isFromDate ? myAddFlightController.setToDate(-1) : myAddFlightController.setFromDate(-1),
                    rightAction: () =>
                        !isFromDate ? myAddFlightController.setToDate(1) : myAddFlightController.setFromDate(1),
                    centerAction: () =>
                        !isFromDate ? myAddFlightController.setToDate(null) : myAddFlightController.setFromDate(null),
                  ),
                  state.isSchedule
                      ? Text(!isFromDate ? "To Date" : "From Date", style: const TextStyle(fontSize: 10))
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddFlightDayElementWidget extends StatelessWidget {
  const AddFlightDayElementWidget(
      {super.key, required this.id, required this.label, this.hasTime = true, required this.b});

  static AddFlightController myAddFlightController = getIt<AddFlightController>();
  final int id;
  final String label;
  final bool hasTime;
  final bool b;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      AddFlightState state = ref.watch(addFlightProvider);
      return Container(
        height: 100,
        width: id == 0 ? 50 : 120,
        padding: const EdgeInsets.only(top: 16),
        margin: EdgeInsets.only(right: id == 7 ? 0 : 50),
        child: Column(
          children: [
            Row(
              children: [
                MyCheckBox(
                  value: id == 0
                      ? WeekDays.values.every((w) => state.weekTimes.keys.contains("${w.index + 1}"))
                      : state.weekTimes.keys.contains("$id") || state.weekTimes.keys.contains("$id"),
                  onChanged: (v) {
                    //it's all!
                    if (id == 0) {
                      if (WeekDays.values.every((w) => state.weekTimes.keys.contains("${w.index + 1}"))) {
                        for (var w in WeekDays.values) {
                          state.weekTimes.remove("${w.index + 1}");
                        }
                      } else {
                        for (var w in WeekDays.values) {
                          state.weekTimes.putIfAbsent("${w.index + 1}", () => [null, null]);
                        }
                      }
                    } else if (state.weekTimes.keys.contains("$id")) {
                      state.weekTimes.remove("$id");
                    } else {
                      state.weekTimes.putIfAbsent("$id", () => [null, null]);
                    }
                    state.setState();
                  },
                ),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
            const SizedBox(height: 12),
            if (hasTime)
              SizedBox(
                height: 33,
                child: MyTimeField(
                  label: "STD",
                  locked: !state.weekTimes.keys.contains("$id"),
                  value: state.weekTimes["$id"]?[0].format_HHmm,
                  onChange: () => myAddFlightController.setDayStd(id),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
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

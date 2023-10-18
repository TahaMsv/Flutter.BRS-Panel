import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/user_class.dart';
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
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/MyButtonPanel.dart';
import 'add_flight_controller.dart';
import 'add_flight_state.dart';

class AddFlightView extends StatelessWidget {
  static AddFlightController addFlightController = getIt<AddFlightController>();

  const AddFlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AddFlightFLNBWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightDateWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightTypeWidget()),
                ],
              ),
              const SizedBox(height: 24),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AddFlightAirlineWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightAircraftWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightFromWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightToWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightSTDWidget()),
                  SizedBox(width: 24),
                  Expanded(child: AddFlightSTAWidget()),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      AddFlightState state = ref.watch(addFlightProvider);
                      return MyButton(
                        label: "Add Flight",
                        disabled: state.validateAddFlight,
                        onPressed: addFlightController.addFlight,
                      );
                    },
                  )
                ],
              ),
            ],
          ),
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
            const SizedBox(width: 24),
            MySwitchButton(value: state.isTest, onChange: (v){
              state.isTest =v;
              state.setState();
            }, label: 'Is Test')
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
        return MyButtonPanel(
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
          locked: state.flightTypeID==0,
          items: BasicClass.systemSetting.airportList,
          label: "From",
          itemToString: (e) => "${e.code} - ${e.code}",
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
          locked: state.flightTypeID==1,
          items: BasicClass.systemSetting.airportList,
          label: "To",
          itemToString: (e) => "${e.code} - ${e.code}",
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
              if(v==0){
                state.from = BasicClass.getAirportByCode(BasicClass.userSetting.airport);
                state.to =null;
              }else{
                state.to = BasicClass.getAirportByCode(BasicClass.userSetting.airport);
                state.from =null;
              }
              state.flightTypeID = v;
              state.setState();
            },
            value: state.flightTypeID);
      },
    );
  }
}

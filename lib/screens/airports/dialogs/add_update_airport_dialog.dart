import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/classes/airport_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/util/basic_class.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MyFieldPicker.dart';
import '../../../widgets/MyTextField.dart';
import '../airports_controller.dart';
import '../airports_state.dart';

class AddUpdateAirportDialog extends ConsumerStatefulWidget {
  const AddUpdateAirportDialog({Key? key, this.airport}) : super(key: key);

  final DetailedAirport? airport;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAirportDialogState();
}

class _AddAirportDialogState extends ConsumerState<AddUpdateAirportDialog> {
  late List<Airport> airports;
  Airport? selectedAirport;
  bool isUpdate = true;

  @override
  void initState() {
    if (widget.airport == null) isUpdate = false;
    airports = BasicClass.systemSetting.airportList;
    selectedAirport =
        airports.firstWhereOrNull((a) => a.timeZone.toString() == widget.airport?.timezone.toString().trim());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AirportsState state = ref.watch(airportsProvider);
    final AirportsController airportsController = getIt<AirportsController>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Container(
        width: 500,
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(!isUpdate ? "Add Airport" : "Edit Airport", style: TextStyles.styleBold24Black),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  children: [
                    MyTextField(
                      controller: state.codeC,
                      height: 50,
                      label: "Code",
                      readOnly: isUpdate,
                      locked: isUpdate,
                      labelStyle: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: state.cityC,
                      height: 50,
                      label: "City Name",
                      labelStyle: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    MyFieldPicker<Airport>(
                        items: airports,
                        value: selectedAirport,
                        onChange: (Airport? a) => setState(() => selectedAirport = a),
                        itemToString: (a) => a.strTimeZone,
                        label: 'Set Timezone'),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    onPressed: () => airportsController.nav.popDialog(),
                    label: 'Cancel',
                    style: TextButton.styleFrom(
                        backgroundColor: MyColors.white3, foregroundColor: MyColors.brownGrey3, elevation: 0),
                    width: 150,
                  ),
                  MyButton(
                    onPressed: () async => airportsController.addUpdateAirport(selectedAirport, isUpdate),
                    label: 'Confirm',
                    style: TextButton.styleFrom(
                        backgroundColor: MyColors.white3, foregroundColor: MyColors.lightIshBlue, elevation: 0),
                    color: MyColors.lightIshBlue,
                    fade: true,
                    width: 150,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

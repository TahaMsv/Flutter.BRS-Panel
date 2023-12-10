import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/constants/abomis_pack_icons.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MySegment.dart';
import '../../../widgets/MyTextField.dart';
import '../aircrafts_controller.dart';
import '../aircrafts_state.dart';

class AddAirCraftDialog extends ConsumerStatefulWidget {
  // final List<TagPhoto> photos;

  const AddAirCraftDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAirCraftDialogState();
}

class _AddAirCraftDialogState extends ConsumerState<AddAirCraftDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AircraftsState state = ref.watch(aircraftsProvider);
    final AircraftsController aircraftsController = getIt<AircraftsController>();
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Add AirCraft", style: TextStyles.styleBold24Black),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyTextField(
                          controller: state.alC,
                          height: 50,
                          label: "AL",
                          locked: true,
                          readOnly: true,
                          labelStyle: const TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: MyTextField(
                          controller: state.typeC,
                          height: 50,
                          label: "Type",
                          labelStyle: const TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: MyTextField(
                          controller: state.registrationC,
                          width: 120,
                          height: 50,
                          label: "Registration",
                          labelStyle: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Bins", style: TextStyles.styleBold16Black),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ListView.builder(
                  itemCount: state.bins.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    return i == state.bins.length
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => aircraftsController.addBin(),
                                label: const Text(
                                  "Add Bin",
                                  style: TextStyle(color: Colors.blue, fontSize: 13),
                                ),
                                icon: const Icon(AbomisIconPack.add, color: Colors.blue, size: 15),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyTextField(
                                      controller: state.binsC[i][0],
                                      onChanged: (String newValue) {
                                        state.bins[i] = state.bins[i].copyWith(compartment: newValue);
                                      },
                                      width: 130,
                                      height: 35,
                                      label: "Compart",
                                      labelStyle: const TextStyle(fontSize: 12)),
                                  MyTextField(
                                      controller: state.binsC[i][1],
                                      onChanged: (String newValue) {
                                        state.bins[i] = state.bins[i].copyWith(binNumber: newValue);
                                      },
                                      width: 130,
                                      height: 35,
                                      label: "BinNumb",
                                      labelStyle: const TextStyle(fontSize: 12)),
                                  SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: MySegment(
                                        items: const ['Cart', 'Uld'],
                                        onChange: (String value) {
                                          setState(() {
                                            state.bins[i] = state.bins[i]
                                                .copyWith(containerType: ["Cart", "Uld"].indexOf(value) + 1);
                                          });
                                        },
                                        value: ["Cart", "Uld"][state.bins[i].containerType - 1]
                                        // "Cart"
                                        ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outlined),
                                    color: Colors.red,
                                    onPressed: () => aircraftsController.removeBin(i),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10)
                            ],
                          );
                  },
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    onPressed: () => aircraftsController.nav.popDialog(),
                    label: 'Cancel',
                    style: TextButton.styleFrom(
                        backgroundColor: MyColors.white3, foregroundColor: MyColors.brownGrey3, elevation: 0),
                    width: 150,
                  ),
                  MyButton(
                    onPressed: () async => aircraftsController.addAirCraft(),
                    label: 'Add Aircraft',
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
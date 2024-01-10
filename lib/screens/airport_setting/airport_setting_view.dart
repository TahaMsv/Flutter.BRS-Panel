import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyExpansionTile2.dart';
import 'package:brs_panel/widgets/MySwitchButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_setting_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyFieldPicker.dart';
import '../../widgets/MyTextField.dart';
import 'airport_setting_controller.dart';
import 'airport_setting_state.dart';

class AirportSettingView extends ConsumerWidget {
  const AirportSettingView({super.key});

  static AirportSettingController controller = getIt<AirportSettingController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(airportSettingProvider);
    return Scaffold(
      appBar: const MyAppBar(),
      body: AirportSettingBody(),
      floatingActionButton: !state.areSettingUpdated
          ? Container()
          : SizedBox(
              height: 30,
              width: 150,
              child: MyButton(
                style: ElevatedButton.styleFrom(foregroundColor: MyColors.white3, backgroundColor: MyColors.mainColor),
                onPressed: () async => await controller.updateSettingRequest(),
                label: "Save Changes",
              ),
            ),
    );
  }
}

class AirportSettingBody extends ConsumerWidget {
  AirportSettingBody({super.key});

  final AirportSettingController controller = getIt<AirportSettingController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(airportSettingProvider);
    final setting = ref.watch(updateDataProvider) ?? AirportSetting.empty();
    const double dividerHeight = 40;
    const double titleMargin = 10;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor, width: 1), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // const Text("Airport:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              // const SizedBox(width: 10),
              Text("${setting.name} (${setting.timeZone})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              // const Text(" Default Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              SettingListWidget(settings: setting.defaultSetting, onChange: (v, s) => controller.onChangeDefaultSetting(v, s)),
            ],
          ),
          const Divider(height: dividerHeight),
          Row(
            children: [
              const Text("Handling Overrides", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 12),
              MyButton(
                onPressed: () async => await controller.addHandling(),
                label: 'Add',
                color: MyColors.boardingBlue,
                fade: true,
                height: 28,
                width: 29,
                child: const Icon(Icons.add, size: 14),
              ),
            ],
          ),
          const SizedBox(height: titleMargin),
          Expanded(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ...setting.handlingsOverride.map((ho) {
                  int indexH = setting.handlingsOverride.indexOf(ho);
                  HandlingAccess? handlingAccess = BasicClass.getHandlingByID(ho.handlingId);
                  return MyExpansionTile2(
                    title: Row(children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Text("Handling ID: ${ho.handlingId}"),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 40,
                              width: 200,
                              child: MyFieldPicker<HandlingAccess>(
                                itemToString: (a) => a.name,
                                label: 'Handling',
                                items: BasicClass.systemSetting.handlingAccess,
                                hasSearch: true,
                                onChange: (v) async {
                                  handlingAccess = v;
                                  ho.handlingId = v?.id;
                                  state.setState();
                                },
                                value: handlingAccess,
                              ),
                            ),
                            const SizedBox(width: 12),
                            MyButton(
                              onPressed: () async => await controller.addAirline(ho),
                              label: 'Add Airline Override',
                              color: MyColors.boardingBlue,
                              fade: true,
                              height: 28,
                              // width: 200,
                              // child: const Icon(Icons.add, size: 14),
                            ),
                          ],
                        ),
                      ),
                      SettingListWidget(settings: ho.setting, onChange: (v, s) => controller.onChangeHOSetting(v, s, ho)),
                      const SizedBox(width: 12),
                      MyButton(
                        onPressed: () async => await controller.removeHandling(ho),
                        label: 'Delete',
                        color: MyColors.red,
                        fade: true,
                        height: 28,
                        width: 29,
                        child: const Icon(Icons.remove, size: 14),
                      ),
                      const SizedBox(width: 12),
                    ]),
                    showLeadingIcon: true,
                    showIcon: false,
                    childrenPadding: EdgeInsets.zero,
                    iconColor: MyColors.brownGrey5,
                    collapsedIconColor: MyColors.brownGrey5,
                    backgroundColor: indexH.isEven ? MyColors.containerGreen2.withOpacity(0.5) : MyColors.containerGreen.withOpacity(0.5),
                    children: [
                      ...ho.airlineOverride.map((ao) {
                        int indexA = ho.airlineOverride.indexOf(ao);
                        return Container(
                          color: indexA.isEven ? MyColors.evenRow : MyColors.oddRow,
                          child: Row(
                            children: [
                              // const Text("Airline Override"),
                              const Spacer(),
                              SizedBox(
                                height: 40,
                                width: 200,
                                child: MyFieldPicker<String>(
                                  itemToString: (a) => a,
                                  label: 'Airline',
                                  items: BasicClass.airlineList,
                                  hasSearch: true,
                                  onChange: (v) async {
                                    ao.al = v ?? "";
                                    state.setState();
                                  },
                                  value: ao.al,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SettingListWidget(settings: ao.setting, onChange: (v, s) => controller.changeAOSetting(v, s, ao, ho)),
                              const SizedBox(width: 12),
                              MyButton(
                                onPressed: () async => await controller.removeAirline(ao, ho),
                                label: 'Delete',
                                color: MyColors.red,
                                fade: true,
                                height: 28,
                                width: 29,
                                child: const Icon(Icons.remove, size: 14),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingListWidget extends StatelessWidget {
  const SettingListWidget({super.key, required this.settings, required this.onChange});

  final List<Setting> settings;
  final Function(dynamic, Setting) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: settings.map((s) {
          return Row(children: [
            const SizedBox(width: 25),
            SettingElement(s, onChange: onChange),
            if (settings.last != s) Container(height: 20, width: 1, color: MyColors.lineColor, margin: const EdgeInsets.only(left: 25)),
          ]);
        }).toList(),
      ),
    );
  }
}

class SettingElement extends StatefulWidget {
  const SettingElement(this.s, {super.key, required this.onChange});

  final Setting s;
  final Function(dynamic, Setting) onChange;

  @override
  State<SettingElement> createState() => _SettingElementState();
}

class _SettingElementState extends State<SettingElement> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.s.value.runtimeType == String) controller.text = widget.s.value;
    if (widget.s.value.runtimeType == int) controller.text = widget.s.value.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.s.type == 'string' || widget.s.type == 'int') {
      return SizedBox(
        width: 250,
        child: MyTextField(
          label: widget.s.key,
          controller: controller,
          onChanged: (string) {
            if (widget.s.type == "int") {
              int? val = int.tryParse(string);
              widget.onChange(val, widget.s);
              return;
            }
            widget.onChange(string, widget.s);
          },
          inputFormatters: widget.s.type == "int" ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
        ),
      );
    }
    if (widget.s.type == 'bool') {
      return MySwitchButton(value: widget.s.value ?? false, onChange: (b) => widget.onChange(b, widget.s), label: widget.s.key);
    }
    return Text(widget.s.value.toString());
  }
}

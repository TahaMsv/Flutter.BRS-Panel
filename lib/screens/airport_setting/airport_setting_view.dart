import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyExpansionTile2.dart';
import 'package:brs_panel/widgets/MySwitchButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_setting_class.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/MyAppBar.dart';
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
      body: const AirportSettingBody(),
      floatingActionButton: state.areSettingUpdated
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
  const AirportSettingBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(airportSettingProvider);
    final setting = ref.watch(settingProvider) ?? AirportSetting.empty();
    const double dividerHeight = 40;
    const double titleMargin = 10;
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor, width: 1), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Airport", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: titleMargin),
          Text("${setting.name} (${setting.timeZone})"),
          const Divider(height: dividerHeight),
          Row(
            children: [
              const Text("Default Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              SettingListWidget(settings: setting.defaultSetting),
            ],
          ),
          const Divider(height: dividerHeight),
          const Text("Handling Overrides", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: titleMargin),
          ...setting.handlingsOverride.map((ho) {
            int indexH = setting.handlingsOverride.indexOf(ho);
            return MyExpansionTile2(
              title: Row(children: [
                Text("Handling ID: ${ho.handlingId}"),
                const Spacer(),
                SettingListWidget(settings: ho.setting),
              ]),
              showLeadingIcon: true,
              showIcon: false,
              childrenPadding: EdgeInsets.zero,
              iconColor: MyColors.brownGrey5,
              collapsedIconColor: MyColors.brownGrey5,
              backgroundColor: indexH.isEven ? MyColors.evenRow : MyColors.oddRow,
              children: ho.airlineOverride.map((ao) {
                int indexA = ho.airlineOverride.indexOf(ao);
                return Row(
                  children: [
                    const SizedBox(width: 40),
                    Text("Airline: ${ao.al}"),
                    const Spacer(),
                    SettingListWidget(settings: ao.setting),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class SettingListWidget extends StatelessWidget {
  const SettingListWidget({super.key, required this.settings});

  final List<Setting> settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: settings.map((s) {
          return Row(children: [
            const SizedBox(width: 25),
            SettingElement(s),
            if (settings.last != s) Container(height: 20, width: 1, color: MyColors.lineColor, margin: const EdgeInsets.only(left: 25)),
          ]);
        }).toList(),
      ),
    );
  }
}

class SettingElement extends StatefulWidget {
  const SettingElement(this.s, {super.key});

  final Setting s;

  @override
  State<SettingElement> createState() => _SettingElementState();
}

class _SettingElementState extends State<SettingElement> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.s.value.runtimeType == String) controller.text = widget.s.value;
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
          inputFormatters: widget.s.type == "int" ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
        ),
      );
    }
    if (widget.s.type == 'bool') {
      return MySwitchButton(value: widget.s.value ?? false, onChange: (b) {}, label: widget.s.key);
    }
    return Text(widget.s.value.toString());
  }
}

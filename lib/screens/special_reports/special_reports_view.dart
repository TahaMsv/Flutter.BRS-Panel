import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyTextField.dart';
import 'special_reports_controller.dart';

class SpecialReportsView extends StatelessWidget {
  const SpecialReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [SpecialReportsPanel()]),
    );
  }
}

class SpecialReportsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();
  static SpecialReportsController controller = getIt<SpecialReportsController>();

  const SpecialReportsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here...",
                controller: searchC,
                showClearButton: true,
                onChanged: (v) {},
              )),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                const Spacer(),
                DotButton(size: 35, onPressed: () {}, icon: Icons.add, color: Colors.blueAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

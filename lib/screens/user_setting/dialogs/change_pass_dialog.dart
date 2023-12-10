import 'package:brs_panel/initialize.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/util/basic_class.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MyTextField.dart';
import '../user_setting_controller.dart';

class ChangePassDialog extends StatefulWidget {
  const ChangePassDialog({Key? key}) : super(key: key);

  @override
  State<ChangePassDialog> createState() => _ChangePassDialogState();
}

class _ChangePassDialogState extends State<ChangePassDialog> {
  final UserSettingController controller = getIt<UserSettingController>();
  final TextEditingController oldPassC = TextEditingController();
  final TextEditingController newPassC = TextEditingController();
  final TextEditingController newPass2C = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final NavigationService nav = getIt<NavigationService>();
    return Dialog(
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 0),
              child: Row(
                children: [
                  Text("Change Password (${BasicClass.userInfo.username})", style: theme.textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(onPressed: nav.pop, icon: const Icon(Icons.close, color: MyColors.brownGrey)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 20),
            SizedBox(
                height: 48, child: MyTextField(label: 'Previous Password', controller: oldPassC, isPassword: true)),
            const SizedBox(height: 20),
            SizedBox(height: 48, child: MyTextField(label: 'New Password', controller: newPassC, isPassword: true)),
            const SizedBox(height: 20),
            SizedBox(
                height: 48, child: MyTextField(label: 'Confirm Password', controller: newPass2C, isPassword: true)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              MyButton(label: "Cancel", onPressed: nav.pop, color: MyColors.brownGrey5),
              const SizedBox(width: 20),
              MyButton(
                  label: "Confirm",
                  onPressed: () async =>
                      await controller.changePassRequest(oldPassC.text, newPassC.text, newPass2C.text)),
              const SizedBox(width: 12),
            ]),
          ],
        ),
      ),
    );
  }
}

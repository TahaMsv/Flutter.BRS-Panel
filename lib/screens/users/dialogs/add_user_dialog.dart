import 'package:brs_panel/initialize.dart';
import 'package:flutter/material.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MySwitchButton.dart';
import '../../../widgets/MyTextField.dart';
import '../users_controller.dart';

class AddUpdateUserDialog extends StatefulWidget {
  final User? user;

  const AddUpdateUserDialog({Key? key, this.user}) : super(key: key);

  @override
  State<AddUpdateUserDialog> createState() => _AddUpdateUserDialogState();
}

class _AddUpdateUserDialogState extends State<AddUpdateUserDialog> {
  late final bool isEditing;
  bool isAdmin = false;
  final TextEditingController handlingC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController alC = TextEditingController();

  @override
  void initState() {
    isEditing = widget.user != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final NavigationService nav = getIt<NavigationService>();
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 0),
              child: Row(
                children: [
                  Text(isEditing ? "Edit User" : "Add User", style: theme.textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(onPressed: nav.pop, icon: const Icon(Icons.close, color: MyColors.brownGrey)),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 3, child: MyTextField(label: "Handling", controller: handlingC)),
                        const SizedBox(width: 120),
                        Expanded(
                          flex: 1,
                          child: MySwitchButton(
                            value: isAdmin,
                            onChange: (b) => setState(() => isAdmin = b),
                            label: "Admin",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyTextField(label: "Name", controller: nameC),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: MyTextField(label: "Username", controller: usernameC)),
                        const SizedBox(width: 20),
                        Expanded(child: MyTextField(label: "AL", controller: alC)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyTextField(label: "Password", controller: passwordC),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(label: "Cancel", onPressed: nav.pop, color: MyColors.brownGrey5),
                const SizedBox(width: 20),
                MyButton(
                  label: "Add User",
                  onPressed: () async {
                    final UsersController controller = getIt<UsersController>();
                    User user = User(
                        id: 0,
                        username: usernameC.text,
                        name: nameC.text,
                        airport: "",
                        al: alC.text,
                        barcodeLength: 10,
                        alCode: "000",
                        waitSecondMin: 3,
                        waitSecondMax: 6,
                        tagOnlyDigit: true,
                        isAdmin: isAdmin,
                        handlingID: 0,
                        isHandlingAdmin: isAdmin,
                        password: passwordC.text);
                    await controller.addUpdateUserRequest(user);
                  },
                ),
                const SizedBox(width: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}

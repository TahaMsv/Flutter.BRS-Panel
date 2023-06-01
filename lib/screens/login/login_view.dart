import 'package:brs_panel/initialize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/ui.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/MyTextField.dart';
import 'login_controller.dart';
import 'login_state.dart';

class LoginView extends StatelessWidget {
  static LoginController myLoginController = getIt<LoginController>();

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: MyColors.lightIshBlue,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoginPanel(),
          ],
        ));
  }
}

class LoginPanel extends ConsumerWidget {
  static LoginController myLoginController = getIt<LoginController>();

  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    LoginState state = ref.read(loginProvider);
    return Container(
      width: 430,
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 75),
          const Text("Baggage Reconciliation System", style: TextStyles.styleBold24Black),
          const SizedBox(height: 12),
          const Text("Input Requested info in order to continue", style: TextStyles.style16Grey),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  placeholder: "Username",
                  controller: state.usernameC,

                ),
                const SizedBox(height: 12),
                MyTextField(
                  isPassword: true,
                  placeholder: "Password",
                  controller: state.passwordC,
                ),
                const SizedBox(height: 24),
                MyButton(
                  onPressed: myLoginController.login,
                  label: 'Enter',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

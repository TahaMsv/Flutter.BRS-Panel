import 'package:brs_panel/core/constants/assest.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/ui.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/MyTextField.dart';
import 'login_controller.dart';
import 'login_state.dart';

class LoginView extends StatefulWidget {
  static LoginController myLoginController = getIt<LoginController>();

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    LoginController controller = getIt<LoginController>();
    controller.getVersion();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => controller.loadPreferences());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                // myLoginController.getServers();
              },
              child: DotButton(
                size: 45,
                icon: Icons.device_hub,
                color: Colors.white,
                onPressed: () async {
                  await LoginView.myLoginController.getServers();
                },
              ),
            ),
            const SizedBox(width: 4),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white.withOpacity(0.4)),
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return Text(ref.watch(selectedServer)?.name ?? 'Default');
                  },
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: Image.asset(AssetImages.loginBG).image, fit: BoxFit.fill),
            // image: DecorationImage(image: Image.asset('assets/images/login_bg.jpg').image, fit: BoxFit.fill),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LoginPanel(),
            ],
          ),
        ));
  }
}

class LoginPanel extends ConsumerWidget {
  static LoginController myLoginController = getIt<LoginController>();

  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    LoginState state = ref.watch(loginProvider);
    final vp = ref.watch(versionProvider);
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
          ),
          if (vp != null) Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Version $vp"),
            ],
          ),
        ],
      ),
    );
  }
}

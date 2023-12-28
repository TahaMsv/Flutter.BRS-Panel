import 'package:bot_toast/bot_toast.dart';
import 'package:brs_panel/screens/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/constants/ui.dart';
import 'core/navigation/router.dart';
import 'initialize.dart';
import 'package:flutterwebapp_reload_detector/flutterwebapp_reload_detector.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    doSomeAsyncStuff();
    super.initState();
  }

  Future<void> doSomeAsyncStuff() async {
    getIt.registerSingleton(ref);
    await initControllers();
    WebAppReloadDetector.onReload(() {
      print('Web Page Reloaded');
      LoginController loginController = getIt<LoginController>();
      loginController.retrieveFromLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      builder: BotToastInit(),
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightAbomis,
      routerConfig: router,
    );
  }
}

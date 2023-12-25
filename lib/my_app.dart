import 'package:bot_toast/bot_toast.dart';
import 'package:brs_panel/screens/flights/flights_controller.dart';
import 'package:brs_panel/screens/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/constants/share_prefrences_keys.dart';
import 'core/constants/ui.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/router.dart';
import 'core/navigation/router_notifier.dart';
import 'initialize.dart';
// import 'dart:html' as html;
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
      // loginController.prefs.setBool(SpKeys.isRefreshed, true);
      loginController.retrieveFromLocalStorage2();
      // bool? firstInit = loginController.prefs.getBool(SpKeys.flightVFirstInit);
      // print('firstInit: ${firstInit}');
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

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../abstracts/controller_abs.dart';
import '../abstracts/navigation_abs.dart';
import 'route_names.dart';
import 'router.dart';

class NavigationService extends BasicNavigationService {
  final List<int> _openedDialogs = [];

  BuildContext get context => rootRouterKey.currentState!.context;

  BuildContext get pageContext => rootRouterKey.currentState!.context;

  BuildContext get dialogContext => _dialogContext!;

  BuildContext? _dialogContext;

  bool get isDialogOpened => _openedDialogs.isNotEmpty;

  final Map<RouteNames, MainController> _registeredControllers = {};

  void registerController(RouteNames route, MainController controller) {
    _registeredControllers.putIfAbsent(route, () => controller);
  }

  void registerControllers(Map<RouteNames, MainController> map) {
    _registeredControllers.addAll(map);
  }

  void initRegisteredController(RouteNames route) {
    log("initRegisteredController ${route.name}");
    _registeredControllers[route]?.onInit.call();
  }

  @override
  void goNamed(
    RouteNames route, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    initRegisteredController(route);
    context.goNamed(route.name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  @override
  bool canPop() {
    return context.canPop();
  }

  @override
  void go(String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  @override
  String namedLocation(RouteNames route, {Map<String, String> pathParameters = const <String, String>{}, Map<String, dynamic> queryParameters = const <String, dynamic>{}}) {
    return context.namedLocation(route.name, pathParameters: pathParameters, queryParameters: queryParameters);
  }

  @override
  void pop<T extends Object?>([T? result]) {
    return context.canPop() ? context.pop(result) : null;
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return context.push(location, extra: extra);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(RouteNames route,
      {Map<String, String> pathParameters = const <String, String>{}, Map<String, dynamic> queryParameters = const <String, dynamic>{}, Object? extra}) {
    initRegisteredController(route);
    return context.pushNamed(route.name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  @override
  void pushReplacement(RouteNames route, {Object? extra}) {
    initRegisteredController(route);
    return context.pushReplacement(route.path, extra: extra);
  }

  @override
  void pushReplacementNamed(RouteNames route, {Map<String, String> pathParameters = const <String, String>{}, Map<String, dynamic> queryParameters = const <String, dynamic>{}, Object? extra}) {
    initRegisteredController(route);
    return context.pushReplacementNamed(route.name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  @override
  void replace(RouteNames route, {Object? extra}) {
    initRegisteredController(route);
    return context.replace(route.path, extra: extra);
  }

  @override
  void replaceNamed(RouteNames route, {Map<String, String> pathParameters = const <String, String>{}, Map<String, dynamic> queryParameters = const <String, dynamic>{}, Object? extra}) {
    initRegisteredController(route);
    return context.replaceNamed(route.name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  @override
  Future dialog(Widget content) async {
    _openedDialogs.add(_openedDialogs.length);
    late dynamic res;
    await showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) {
        _dialogContext = context;
        return content;
      },
    ).then((value) {
      log("Dialog Then $value");
      _openedDialogs.removeLast();
      if (_openedDialogs.isEmpty) _dialogContext = null;
      res = value;
      return value;
    });
    return res;
  }

  @override
  void hideSnackBars() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  void popDialog({result, Function? onPop}) {
    Navigator.pop(context, result);
    onPop?.call();
  }

  @override
  void snackbar(Widget content, {Color? backgroundColor, SnackBarAction? action, Duration? duration, IconData? icon, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: margin,
      padding: padding,
      content: icon == null
          ? content
          : Row(
              children: [Icon(icon, color: Colors.white), const SizedBox(width: 8), Expanded(child: content)],
            ),
      backgroundColor: backgroundColor,
      action: action,
      duration: duration ?? const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void goBack({dynamic result, required void Function()? onPop}) {
    pop(result);
    onPop?.call();
    // navigatorKey.currentState!.pop(result);
  }
}

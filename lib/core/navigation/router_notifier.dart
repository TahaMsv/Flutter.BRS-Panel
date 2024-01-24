import 'package:brs_panel/screens/aircrafts/aircrafts_view.dart';
import 'package:brs_panel/screens/airline_ulds/airline_ulds_view.dart';
import 'package:brs_panel/screens/airlines/airlines_view.dart';
import 'package:brs_panel/screens/airport_carts/airport_carts_view.dart';
import 'package:brs_panel/screens/airports/airports_view.dart';
import 'package:brs_panel/screens/barcode_generator/barcode_generator_view.dart';
import 'package:brs_panel/screens/bsm/bsm_view.dart';
import 'package:brs_panel/screens/flight_details/flight_details_view.dart';
import 'package:brs_panel/screens/flight_summary/flight_summary_view.dart';
import 'package:brs_panel/screens/flights/flights_view.dart';
import 'package:brs_panel/screens/user_setting/user_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/add_flight/add_flight_view.dart';
import '../../screens/airport_sections/airport_sections_view.dart';
import '../../screens/airport_setting/airport_setting_view.dart';
import '../../screens/home/home_view.dart';
import '../../screens/login/login_state.dart';
import '../../screens/login/login_view.dart'; // final userProvider = StateProvider<User?>((ref) => null);
import '../../screens/special_reports/special_reports_view.dart';
import '../../screens/users/users_view.dart';
import 'route_names.dart';

/// This notifier is meant to implement the [Listenable] our [GoRouter] needs.
///
/// We aim to trigger redirects whenever's needed.
/// This is done by calling our (only) listener everytime we want to notify stuff.
/// This allows to centralize global redirecting logic in this class.
/// In this simple case, we just listen to auth changes.
///
/// SIDE NOTE.
/// This might look overcomplicated at a first glance;
/// Instead, this method aims to follow some good some good practices:
///   1. It doesn't require us to pipe down any `ref` parameter
///   2. It works as a complete replacement for [ChangeNotifier] (it's a [Listenable] implementation)
///   3. It allows for listening to multiple providers if needed (we do have a [Ref] now!)
class RouterNotifier extends AutoDisposeAsyncNotifier<void> implements Listenable {
  VoidCallback? routerListener;
  bool isAuth = false; // Useful for our global redirect functio

  @override
  Future<void> build() async {
    // One could watch more providers and write logic accordingly

    isAuth = ref.watch(userProvider) != null;
    ref.listenSelf((_, __) {
      // One could write more conditional logic for when to call redirection
      if (state.isLoading) return;
      routerListener?.call();
    });
  }

  /// Redirects the user when our authentication changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (this.state.isLoading || this.state.hasError) return null;

    // final isSplash = state.location == RouteNames.splash.path;
    const isSplash = false;

    if (isSplash) {
      return isAuth ? RouteNames.home.path : RouteNames.login.path;
    }
    if (!isAuth) return RouteNames.login.path;
    print("isAuth $isAuth");
    final isLoggingIn = state.location == RouteNames.login.path;
    print("isLoggingIn $isLoggingIn");
    if (isLoggingIn) return isAuth ? RouteNames.flights.path : null;

    return isAuth ? null : RouteNames.flights.path;
  }

  /// Our application routes. Obtained through code generation
  List<GoRoute> get routes => [
        MyRoute(
          // controller: RouteNames.login.controller,
          name: RouteNames.login.name,
          path: RouteNames.login.path,
          pageBuilder: (context, state) {
            // LoginController loginController = getIt<LoginController>();
            return NoTransitionPage<void>(key: state.pageKey, child: const LoginView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.home.name,
          path: RouteNames.home.path,
          pageBuilder: (context, state) {
            // HomeController homeController = getIt<HomeController>();
            return NoTransitionPage<void>(key: state.pageKey, child: const HomeView());
          },
        ),
        MyRoute(
            // controller: RouteNames.home.controller,
            name: RouteNames.flights.name,
            path: RouteNames.flights.path,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(key: state.pageKey, child: const FlightsView());
            },
            routes: [
              MyRoute(
                // controller: RouteNames.home.controller,
                name: RouteNames.addFlight.name,
                path: RouteNames.addFlight.path,

                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(key: state.pageKey, child: const AddFlightView());
                },
              ),
              MyRoute(
                name: RouteNames.flightDetails.name,
                path: '${RouteNames.flightDetails.path}/:flightID',
                pageBuilder: (context, state) {
                  final flightID = int.parse(state.pathParameters["flightID"].toString());
                  return NoTransitionPage<void>(key: state.pageKey, child: FlightDetailsView(flightID: flightID));
                },
              ),
              MyRoute(
                name: RouteNames.flightSummary.name,
                path: '${RouteNames.flightSummary.path}/:flightID',
                pageBuilder: (context, state) {
                  final flightID = int.parse(state.pathParameters["flightID"].toString());
                  return NoTransitionPage<void>(key: state.pageKey, child: FlightSummaryView(flightID: flightID));
                },
              ),
            ]),
        MyRoute(
            name: RouteNames.airlines.name,
            path: RouteNames.airlines.path,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(key: state.pageKey, child: const AirlinesView());
            },
            routes: [
              MyRoute(
                name: RouteNames.airlineUlds.name,
                path: RouteNames.airlineUlds.path,
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(key: state.pageKey, child: const AirlineUldsView());
                },
              )
            ]),
        MyRoute(
            name: RouteNames.airports.name,
            path: RouteNames.airports.path,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(key: state.pageKey, child: const AirportsView());
            },
            routes: [
              MyRoute(
                // controller: RouteNames.home.controller,
                name: RouteNames.airportCarts.name,
                path: RouteNames.airportCarts.path,

                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(key: state.pageKey, child: const AirportCartsView());
                },
              ),
              MyRoute(
                name: RouteNames.airportSections.name,
                path: RouteNames.airportSections.path,
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(key: state.pageKey, child: const AirportSectionsView());
                },
              ),
              MyRoute(
                name: RouteNames.airportSetting.name,
                path: RouteNames.airportSetting.path,
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(key: state.pageKey, child: const AirportSettingView());
                },
              ),
            ]),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.aircrafts.name,
          path: RouteNames.aircrafts.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const AircraftsView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.users.name,
          path: RouteNames.users.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const UsersView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.specialReports.name,
          path: RouteNames.specialReports.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const SpecialReportsView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.userSetting.name,
          path: RouteNames.userSetting.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const UserSettingView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.bsm.name,
          path: RouteNames.bsm.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const BsmView());
          },
        ),
        MyRoute(
          // controller: RouteNames.home.controller,
          name: RouteNames.barcodeGenerator.name,
          path: RouteNames.barcodeGenerator.path,

          pageBuilder: (context, state) {
            return NoTransitionPage<void>(key: state.pageKey, child: const BarcodeGeneratorView());
          },
        ),
      ];

  /// Adds [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method on creation to handle its
  /// internal [ChangeNotifier].
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  /// Removes [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method when disposing,
  /// so that it removes its callback when destroyed.
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}

final routerNotifierProvider = AutoDisposeAsyncNotifierProvider<RouterNotifier, void>(() {
  return RouterNotifier();
});

/// A simple extension to determine wherever should we redirect our users
// extension RedirecttionBasedOnRole on UserRole {
//   /// Redirects the users based on [this] and its current [location]
//   String? redirectBasedOn(String location) {
//     switch (this) {
//       case UserRole.admin:
//         return null;
//       case UserRole.verifiedUser:
//       case UserRole.unverifiedUser:
//         if (location == AdminPage.path) return HomePage.path;
//         return null;
//       case UserRole.guest:
//       case UserRole.none:
//         if (location != HomePage.path) return HomePage.path;
//         return null;
//     }
//   }
// }

class MyRoute extends GoRoute {
  // final MainController controller;

  MyRoute({
    required super.path,
    // required this.controller,
    super.name,
    super.routes,
    super.pageBuilder,
  });
}

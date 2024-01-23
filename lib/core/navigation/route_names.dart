import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum RouteNames {
  login,
  home,
  flights,
  airlines,
  aircrafts,
  airports,
  specialReports,
  users,
  userSetting,
  addFlight,
  flightDetails,
  flightSummary,
  checkin,
  board,
  airlineUlds,
  airportCarts,
  airportSections,
  airportSetting,
  bsm,
  barcodeGenerator,
  webView,
}

extension RouteNamesDetails on RouteNames {
  String get path {
    switch (this) {
      case RouteNames.addFlight:
        return 'addFlight';
      case RouteNames.flightDetails:
        return 'flightDetails';
      case RouteNames.airlineUlds:
        return 'airlineUlds';
      case RouteNames.flightSummary:
        return 'flightSummary';
      case RouteNames.login:
        return '/login';
      case RouteNames.airportCarts:
        return 'airportCarts';
      case RouteNames.airportSections:
        return 'airportSections';
      case RouteNames.airportSetting:
        return 'airportSetting';
      case RouteNames.webView:
        return '/webview';
      default:
        return "/$name";
    }
  }

  String get appropriateName {
    switch (this) {
      case RouteNames.specialReports:
        return "Special Reports";
      case RouteNames.userSetting:
        return "User Setting";
      case RouteNames.addFlight:
        return "Add Flight";
      case RouteNames.flightDetails:
        return "Flight Details";
      case RouteNames.flightSummary:
        return "Flight Summary";
      case RouteNames.airlineUlds:
        return "Airline Ulds";
      case RouteNames.airportCarts:
        return "Airport Carts";
      case RouteNames.airportSections:
        return "Airport Sections";
      case RouteNames.airportSetting:
        return "Airport Setting";
      case RouteNames.barcodeGenerator:
        return "Barcode Generator";
      default:
        return name.capitalizeFirst!;
    }
  }

  String get title {
    switch (this) {
      default:
        // return (name.characters.first.toUpperCase() + name.replaceFirst(name.characters.first, ""));
        return appropriateName;
    }
  }

  bool get isMainRoute {
    return [
      RouteNames.flights,
      RouteNames.airlines,
      RouteNames.airports,
      RouteNames.aircrafts,
      RouteNames.bsm,
      RouteNames.barcodeGenerator,
      RouteNames.users,
      RouteNames.specialReports,
    ].contains(this);
  }

// MainController get controller {
//   switch(this){
//     case RouteNames.splash:
//       return LoginController();
//     case RouteNames.login:
//       return LoginController();
//     case RouteNames.home:
//       return HomeController();
//     case RouteNames.flights:
//       return FlightsController();
//     case RouteNames.airlines:
//      return AirlinesController();
//     case RouteNames.aircrafts:
//      return AircraftsController();
//     case RouteNames.airports:
//       return AirportsController();
//     case RouteNames.users:
//       return UsersController();
//   }
// }
}

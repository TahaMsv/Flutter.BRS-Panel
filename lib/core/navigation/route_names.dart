import 'package:flutter/material.dart';

enum RouteNames {
  login,
  home,
  flights,
  airlines,
  aircrafts,
  airports,
  users,
  addFlight,
  flightDetails,
  checkin,
  board,
  airlineUlds,
  airportCarts,

}

extension RouteNamesDetails on RouteNames {
  String get path {
    switch (this) {
      case RouteNames.addFlight:
        return 'addFlight';
      case RouteNames.flightDetails:
        return 'details';
      case RouteNames.airlineUlds:
        return 'airlineUlds';
      case RouteNames.login:
        return '/login';
      case RouteNames.airportCarts:
        return 'airportCarts';
      default:
        return "/$name";
    }
  }

  String get title {
    switch (this) {
      default:
        return (name.characters.first.toUpperCase() + name.replaceFirst(name.characters.first, ""));
    }
  }

  bool get isMainRoute {
    return [
      RouteNames.flights,
      RouteNames.airlines,
      RouteNames.airports,
      RouteNames.aircrafts,
      RouteNames.users,
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

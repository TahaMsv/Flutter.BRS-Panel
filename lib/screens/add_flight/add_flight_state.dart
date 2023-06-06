import 'package:brs_panel/core/classes/user_class.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/screens/add_flight/usecases/add_flight_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addFlightProvider = ChangeNotifierProvider.autoDispose<AddFlightState>((_) => AddFlightState());

class AddFlightState extends ChangeNotifier {


  void setState() => notifyListeners();

  DateTime fromDate = DateTime.now();
  DateTime? toDate;
  TimeOfDay? std;
  TimeOfDay? sta;
  Airport? airport;
  Airport? from = BasicClass.getAirportByCode(BasicClass.userSetting.airport);
  Airport? to;
  TextEditingController flnbC = TextEditingController();
  Airline? al = BasicClass.getAirlineByCode(BasicClass.userSetting.al);
  Aircraft? aircraft;
  int? barcodeLength;
  int flightTypeID = 0;

  AddFlightRequest createAddFlightRequest() => AddFlightRequest(
        flnb: flnbC.text,
        fromDate: fromDate,
        toDate: fromDate,
        std: std!,
        sta: sta,
        airport: airport,
        aircraft: aircraft,
        from: from!,
        to: to!,
        al: al!,
        barcodeLength: 10,
        flightTypeID: flightTypeID,
      );

 bool get validateAddFlight => std==null ||from ==null || to==null ||al==null;
  ///bool loading = false;
}

///final userProvider = StateProvider<User?>((ref) => null);

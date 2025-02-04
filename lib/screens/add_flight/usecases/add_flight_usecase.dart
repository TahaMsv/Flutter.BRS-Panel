import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/core/enums/week_days_enum.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../add_flight_repository.dart';

class AddFlightUseCase extends UseCase<AddFlightResponse,AddFlightRequest> {
  AddFlightUseCase();

  @override
  Future<Either<Failure, AddFlightResponse>> call({required AddFlightRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AddFlightRepository repository = AddFlightRepository();
    return repository.addFlight(request);
  }

}

class AddFlightRequest extends Request {
  final DateTime fromDate;
  final DateTime toDate;
  final TimeOfDay? std;
  final TimeOfDay? sta;
  final Airport? airport;
  final Airport? from;
  final Airport? to;
  final String flnb;
  final String? al;
  final Aircraft? aircraft;
  final int barcodeLength;
  final int flightTypeID;
  final bool isTest;
  final bool isSchedule;
  final Map<String, Map<String,String>> weekDaysTime;

  AddFlightRequest({
    required this.flnb,
    required this.fromDate,
    required this.toDate,
    required this.std,
    required this.sta,
    required this.airport,
    required this.aircraft,
    required this.from,
    required this.to,
    required this.al,
    required this.barcodeLength,
    required this.flightTypeID,
    required this.isTest,

    required this.isSchedule,
    required this.weekDaysTime,
});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "AddFlight",
      "Token":token,
      "Request": {
        "FlightDate": fromDate.format_yyyyMMdd,
        "STD": std.format_HHmm,
        "STA": sta.format_HHmm,
        "Airport": BasicClass.userSetting.airport,
        "ToCity": to?.code,
        "FromCity": from?.code,
        "FLNB": flnb,
        "AL": al,
        "Registration": aircraft?.registration,
        "BarcodeLength": barcodeLength,
        "FlightType": flightTypeID,
        "AircraftID":aircraft?.id,
        "IsTest":isTest,
        "ToDate": toDate.format_yyyyMMdd,
        "IsSchedule": isSchedule,
        "WeekDaysTime": weekDaysTime
      }
    }
  };

  Failure? validate(){
    if(flnb.isEmpty){
      return ValidationFailure(code: 1, msg: "Flight Number is Required!", traceMsg: '');
    }
    if(from==null){
      return ValidationFailure(code: 1, msg: "From is Required!", traceMsg: '');
    }
    if(to==null){
      return ValidationFailure(code: 1, msg: "To is Required!", traceMsg: '');
    }
    if(al==null){
      return ValidationFailure(code: 1, msg: "Airline is Required!", traceMsg: '');
    }
    if(std==null){
      if(isSchedule){
        if(weekDaysTime.values.any((element) => (element["STA"]??'').isEmpty || (element["STD"]??'').isEmpty)){
          int id = int.parse(weekDaysTime.entries.firstWhere((element) =>  (element.value["STA"]??'').isEmpty || (element.value["STD"]??'').isEmpty).key);
          return ValidationFailure(code: 1, msg: "${WeekDays.values[id-1].label} ${(weekDaysTime[id.toString()]!["STD"]??'').isEmpty?'STD':'STA'} is Required!", traceMsg: '');
        }else{
          return null;
        }
      }else{
        return ValidationFailure(code: 1, msg: "STD is Required!", traceMsg: '');
      }

    }
    if(sta==null){
      return ValidationFailure(code: 1, msg: "STA is Required!", traceMsg: '');
    }

    return null;
  }
}


class AddFlightResponse extends Response {
  final List<Flight> flights;

  AddFlightResponse({required int status, required String message, required this.flights})
      : super(status: status, message: message, body:flights.map((e)=>e.toJson()).toList());

  factory AddFlightResponse.fromResponse(Response res) => AddFlightResponse(
        status: res.status,
        message: res.message,
        flights: List<Flight>.from(res.body.map((x) => Flight.fromJson(x))),
      );
}

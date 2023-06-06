import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
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
  final TimeOfDay std;
  final TimeOfDay? sta;
  final Airport? airport;
  final Airport from;
  final Airport to;
  final String flnb;
  final Airline al;
  final Aircraft? aircraft;
  final int barcodeLength;
  final int flightTypeID;

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
        "ToCity": to.code,
        "FromCity": from.code,
        "FLNB": flnb,
        "AL": al.al,
        "Registration": aircraft?.registration,
        "BarcodeLength": barcodeLength,
        "FlightType": flightTypeID,
        "AircraftID":aircraft?.id,
      }
    }
  };

  Failure? validate(){
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

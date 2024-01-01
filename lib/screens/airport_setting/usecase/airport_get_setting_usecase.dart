import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_setting_class.dart';
import '../airport_setting_repository.dart';

class AirportGetSettingUseCase extends UseCase<AirportGetSettingResponse, AirportGetSettingRequest> {
  AirportGetSettingUseCase();

  @override
  Future<Either<Failure, AirportGetSettingResponse>> call({required AirportGetSettingRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportSettingRepository repository = AirportSettingRepository();
    return repository.airportGetSetting(request);
  }
}

class AirportGetSettingRequest extends Request {
  final String airportCode;

  AirportGetSettingRequest({required this.airportCode});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "AirportGetSetting",
          "Request": {"Airport": "THR"}
        }
      };

  Failure? validate() {
    return null;
  }
}

class AirportGetSettingResponse extends Response {
  final AirportSetting? airportSetting;

  AirportGetSettingResponse({required int status, required String message, required this.airportSetting}) : super(status: status, message: message, body: airportSetting?.toJson());

  factory AirportGetSettingResponse.fromResponse(Response res) => AirportGetSettingResponse(
        status: res.status,
        message: res.message,
        airportSetting: AirportSetting.fromJson(res.body ?? {}),
      );
}

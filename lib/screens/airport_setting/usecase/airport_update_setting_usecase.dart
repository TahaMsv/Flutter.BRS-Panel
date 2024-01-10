import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_setting_class.dart';
import '../airport_setting_repository.dart';

class AirportUpdateSettingUseCase extends UseCase<AirportUpdateSettingResponse, AirportUpdateSettingRequest> {
  AirportUpdateSettingUseCase();

  @override
  Future<Either<Failure, AirportUpdateSettingResponse>> call({required AirportUpdateSettingRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportSettingRepository repository = AirportSettingRepository();
    return repository.airportUpdateSetting(request);
  }
}

class AirportUpdateSettingRequest extends Request {
  final AirportSetting airportSetting;

  AirportUpdateSettingRequest({required this.airportSetting});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {"Token": token, "Execution": "AirportSettingInsertOrUpdate", "Request": airportSetting.toJson()}
      };

  Failure? validate() {
    String? msg;
    if (airportSetting.defaultSetting.any((s) => s.value == null || (s.value is String && s.value.isEmpty))) {
      msg = "Please fill all the information!";
    } else if (airportSetting.handlingsOverride.any((ho) => ho.setting.any((s) => s.value == null || (s.value is String && s.value.isEmpty)))) {
      msg = "Please fill all the information!";
    } else if (airportSetting.handlingsOverride.any((ho) => ho.handlingId == null)) {
      msg = "Please fill all the information!";
    } else if (airportSetting.handlingsOverride.any((ho) => ho.airlineOverride.any((ao) => ao.al.isEmpty))) {
      msg = "Please fill all the information!";
    } else if (airportSetting.handlingsOverride.any((ho) => ho.airlineOverride.any((ao) => ao.setting.any((s) => s.value == null || (s.value is String && s.value.isEmpty))))) {
      msg = "Please fill all the information!";
    }
    return msg == null ? null : ValidationFailure(code: -1, msg: msg, traceMsg: "AddUpdateUserUseCase>Validation");
  }
}

class AirportUpdateSettingResponse extends Response {
  // final AirportSetting? airportSetting;

  AirportUpdateSettingResponse({required int status, required String message}) : super(status: status, message: message, body: null);

  factory AirportUpdateSettingResponse.fromResponse(Response res) => AirportUpdateSettingResponse(
        status: res.status,
        message: res.message,
        // airportSetting: AirportSetting.fromJson(res.body ?? {}),
      );
}

import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_section_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../airport_Sections_repository.dart';

class AirportGetSectionsUseCase extends UseCase<AirportGetSectionsResponse, AirportGetSectionsRequest> {
  AirportGetSectionsUseCase();

  @override
  Future<Either<Failure, AirportGetSectionsResponse>> call({required AirportGetSectionsRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportSectionsRepository repository = AirportSectionsRepository();
    return repository.airportGetSections(request);
  }
}

class AirportGetSectionsRequest extends Request {
  final Airport airport;

  AirportGetSectionsRequest({required this.airport});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "AirportGetSections",
          "Token": token,
          "Request": {"Airport": airport.code}
        }
      };

  Failure? validate() {
    return null;
  }
}

class AirportGetSectionsResponse extends Response {
  final AirportSections? airportSections;

  AirportGetSectionsResponse({required int status, required String message, required this.airportSections})
      : super(status: status, message: message, body: airportSections?.toJson());

  factory AirportGetSectionsResponse.fromResponse(Response res) => AirportGetSectionsResponse(
        status: res.status,
        message: res.message,
        airportSections: AirportSections.fromJson(res.body ?? {}),
      );
}

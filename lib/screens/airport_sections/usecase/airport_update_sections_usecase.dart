import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_section_class.dart';
import '../airport_Sections_repository.dart';

class AirportUpdateSectionsUseCase extends UseCase<AirportUpdateSectionsResponse, AirportUpdateSectionsRequest> {
  AirportUpdateSectionsUseCase();

  @override
  Future<Either<Failure, AirportUpdateSectionsResponse>> call({required AirportUpdateSectionsRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportSectionsRepository repository = AirportSectionsRepository();
    return repository.airportUpdateSections(request);
  }
}

class AirportUpdateSectionsRequest extends Request {
  final AirportSections sections;

  AirportUpdateSectionsRequest({required this.sections});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {"Execution": "PositionSectionInsertOrUpdate", "Token": token, "Request": sections.toJson()}
      };

  Failure? validate() {
    return null;
  }
}

class AirportUpdateSectionsResponse extends Response {
  final AirportSections? airportSections;

  AirportUpdateSectionsResponse({required int status, required String message, required this.airportSections})
      : super(status: status, message: message, body: airportSections?.toJson());

  factory AirportUpdateSectionsResponse.fromResponse(Response res) => AirportUpdateSectionsResponse(
        status: res.status,
        message: res.message,
        airportSections: AirportSections.fromJson(res.body ?? {}),
      );
}

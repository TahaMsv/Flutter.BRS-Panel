import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/delete_tag_usecase.dart';
import '../usecases/flight_get_details_usecase.dart';
import '../usecases/flight_get_tag_details_usecase.dart';
import '../usecases/get_container_pdf_usecase.dart';

abstract class FlightDetailsRepositoryInterface {
  Future<Either<Failure, FlightGetDetailsResponse>> flightGetDetails(FlightGetDetailsRequest request);
  Future<Either<Failure, FlightGetTagMoreDetailsResponse>> flightGetTagMoreDetails(FlightGetTagMoreDetailsRequest request);
  Future<Either<Failure, GetContainerReportResponse>> getContainerReport(GetContainerReportRequest request);
  Future<Either<Failure, DeleteTagResponse>> deleteTag(DeleteTagRequest request);
}
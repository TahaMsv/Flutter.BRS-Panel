import 'package:brs_panel/screens/flight_details/usecases/flight_get_details_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_more_details_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import '../../widgets/TagDetailsDialog.dart';
import 'flight_details_state.dart';
import 'usecases/flight_get_tag_details_usecase.dart';

class FlightDetailsController extends MainController {
  late FlightDetailsState flightDetailsState = ref.read(flightDetailsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<FlightDetails?> flightGetDetails(int flightID) async {
    // final fdP = ref.read(detailsProvider.notifier);
    FlightDetails? flightDetails;
    FlightGetDetailsUseCase flightGetDetailsUsecase = FlightGetDetailsUseCase();
    FlightGetDetailsRequest flightGetDetailsRequest = FlightGetDetailsRequest(flightID: flightID);
    final fOrR = await flightGetDetailsUsecase(request: flightGetDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetDetails(flightID)), (r) {
      flightDetails = r.details;
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return flightDetails;
  }
  
  Future<TagMoreDetails?> flightGetTagMoreDetails(int flightID,FlightTag tag) async {
    // final fdP = ref.read(detailsProvider.notifier);
    TagMoreDetails? moreDetails;
    FlightGetTagMoreDetailsUseCase flightGetTagMoreDetailsUsecase = FlightGetTagMoreDetailsUseCase();
    FlightGetTagMoreDetailsRequest flightGetTagMoreDetailsRequest = FlightGetTagMoreDetailsRequest(flightID: flightID,tag: tag);
    final fOrR = await flightGetTagMoreDetailsUsecase(request: flightGetTagMoreDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetTagMoreDetails(flightID,tag)), (r) {
      moreDetails = r.details;
      print(r.details.toJson());
      nav.dialog(TagDetailsDialog(tag: tag, moreDetails: r.details,));
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return moreDetails;
  }

}

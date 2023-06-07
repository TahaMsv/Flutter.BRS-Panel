import 'package:brs_panel/screens/airline_ulds/usecases/airline_get_ulds_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/airline_uld_class.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airline_ulds_state.dart';

class AirlineUldsController extends MainController {
  late AirlineUldsState airlineUldsState = ref.read(airlineUldsProvider);

  // UseCase UseCase = UseCase(repository: Repository());



  Future<List<AirlineUld>?> airlineGetUldList(Airline al) async {
    List<AirlineUld>? ulds;
    AirlineGetUldListUseCase airlineGetUldListUsecase = AirlineGetUldListUseCase();
    AirlineGetUldListRequest airlineGetUldListRequest = AirlineGetUldListRequest(al: al);
    final fOrR = await airlineGetUldListUsecase(request: airlineGetUldListRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airlineGetUldList(al)), (r) {
      ulds = r.ulds;
      final uldListP = ref.read(uldListProvider.notifier);
      uldListP.setAirlineUlds(r.ulds);
    });
    return ulds;
  }

  void addUld() {

  }
}

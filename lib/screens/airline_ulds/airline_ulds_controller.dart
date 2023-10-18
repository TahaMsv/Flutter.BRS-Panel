import 'package:brs_panel/core/abstracts/warning_abs.dart';
import 'package:brs_panel/core/util/confirm_operation.dart';
import 'package:brs_panel/screens/airline_ulds/usecases/airline_delete_uld_usecase.dart';
import 'package:brs_panel/screens/airline_ulds/usecases/airline_get_ulds_usecase.dart';
import 'package:brs_panel/screens/airline_ulds/usecases/airline_update_uld_usecase.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/airline_uld_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import '../../core/util/handlers/success_handler.dart';
import '../../core/util/handlers/warning_handler.dart';
import 'airline_ulds_state.dart';
import 'dialogs/add_update_airline_uld_dailog.dart';
import 'usecases/airline_add_uld_usecase.dart';

class AirlineUldsController extends MainController {
  late AirlineUldsState airlineUldsState = ref.read(airlineUldsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<List<TagContainer>?> airlineGetUldList() async {
    String? al = ref.read(selectedAirlineProvider);
    if (al == null) return null;
    List<TagContainer>? ulds;
    AirlineGetUldListUseCase airlineGetUldListUsecase = AirlineGetUldListUseCase();
    AirlineGetUldListRequest airlineGetUldListRequest = AirlineGetUldListRequest(al: al);
    final fOrR = await airlineGetUldListUsecase(request: airlineGetUldListRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airlineGetUldList()), (r) {
      ulds = r.ulds;
      final uldListP = ref.read(uldListProvider.notifier);
      uldListP.setAirlineUlds(r.ulds);
    });
    return ulds;
  }

  void addUld() {
    nav.dialog(const AddUpdateAirlineDialogDialog(editingUld: null));
  }

  Future<TagContainer?> airlineAddUld(String al, String code, String type) async {
    TagContainer? uld;
    AirlineAddUldUseCase airlineAddUldUsecase = AirlineAddUldUseCase();
    AirlineAddUldRequest airlineAddUldRequest = AirlineAddUldRequest(al: al, uldCode: code, uldType: type);
    final fOrR = await airlineAddUldUsecase(request: airlineAddUldRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airlineAddUld(al, code, type)), (r) {
      uld = r.uld;
      final uldListP = ref.read(uldListProvider.notifier);
      uldListP.addAirlineUld(r.uld);
    });
    return uld;
  }

  Future<TagContainer?> airlineUpdateUld(TagContainer updating) async {
    final selectedAirlineP = ref.read(selectedAirlineProvider);
    TagContainer? uld;

    AirlineUpdateUldUseCase airlineUpdateUldUsecase = AirlineUpdateUldUseCase();
    AirlineUpdateUldRequest airlineUpdateUldRequest = AirlineUpdateUldRequest(id: updating.id!, al: selectedAirlineP!, uldCode: updating.code, uldType: updating.typeId);
    final fOrR = await airlineUpdateUldUsecase(request: airlineUpdateUldRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airlineUpdateUld(updating)), (r) {
      uld = r.uld;
      final uldListP = ref.read(uldListProvider.notifier);
      uldListP.updateUld(r.uld);
    });
    return uld;
  }

  void updateUld(TagContainer uld) {
    nav.dialog(AddUpdateAirlineDialogDialog(editingUld: uld));
  }

  void deleteUld(TagContainer uld)async {
    bool confirm = await ConfirmOperation.getConfirm(Operation(message: "You are Deleting Uld ${uld.code}", title: "Are You Sure", actions: ["Cancel","Confirm"],type: OperationType.warning));
    if(confirm){
      airlineDeleteUld(uld);
    }
  }

  Future<bool?> airlineDeleteUld(TagContainer uld) async {
    bool? status;
    final selectedAirlineP = ref.read(selectedAirlineProvider);
    AirlineDeleteUldUseCase airlineDeleteUldUsecase = AirlineDeleteUldUseCase();
    AirlineDeleteUldRequest airlineDeleteUldRequest = AirlineDeleteUldRequest(id: uld.id!, al: selectedAirlineP!);
    final fOrR = await airlineDeleteUldUsecase(request: airlineDeleteUldRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airlineDeleteUld(uld)), (r) {
      status = r.isSuccess;
      final uldListP = ref.read(uldListProvider.notifier);
      uldListP.removeAirlineUld(uld.id!);
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Uld Deleted Successfully"));
    });
    return status;
  }
}

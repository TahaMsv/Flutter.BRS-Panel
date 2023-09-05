import 'package:brs_panel/screens/bsm/usecases/add_bsm_usecase.dart';
import 'package:brs_panel/screens/bsm/usecases/bsm_list_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'bsm_state.dart';

class BsmController extends MainController {
  late BsmState bsmState = ref.read(bsmProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  @override
  onInit() {
    bsmList(DateTime.now());
  }

  Future<List<BsmResult>> bsmList(DateTime dt) async {
    List<BsmResult> bsms = [];
    BsmListUseCase bsmListUsecase = BsmListUseCase();
    BsmListRequest bsmListRequest = BsmListRequest(date: DateTime.now());
    bsmState.loadingBSM = true;
    bsmState.setState();
    final fOrR = await bsmListUsecase(request: bsmListRequest);
    bsmState.loadingBSM = false;
    bsmState.setState();

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => bsmList(dt)), (r) {
      bsms = r.bsmLists;
      final bsmList = ref.read(bsmListProvider.notifier);
      bsmList.setBsms(bsms);
    });
    return bsms;
  }

  Future<BsmResult?> addBsm(String msg) async {
    BsmResult? bsmResult;
    AddBSMUseCase addBsmUsecase = AddBSMUseCase();
    AddBSMRequest addBSMRequest = AddBSMRequest(msg: msg);
    final fOrR = await addBsmUsecase(request: addBSMRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => addBsm(msg)), (r) {
      bsmResult = r.bsmResult;
      final bsmList = ref.read(bsmListProvider.notifier);
      bsmState.newBsmC.clear();
      bsmList.insertBsm(0,r.bsmResult);
    });
    return bsmResult;
  }
}

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/constants/data_bases_keys.dart';
import '../../core/data_base/web_data_base.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'bsm_state.dart';
import 'usecases/add_bsm_usecase.dart';
import 'usecases/bsm_list_usecase.dart';

class BsmController extends MainController {
  late BsmState bsmState = ref.read(bsmProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  @override
  onInit() {
    bsmList(ref.read(bsmDateProvider.notifier).state);
  }

  Future<void> retrieveBSMScreenFromLocalStorage() async {
    late DateTime savedDateTime;
    final savedDateTimeString = await SessionStorage().getString(SsKeys.bsmDateP) ?? '';
    savedDateTime = savedDateTimeString.isNotEmpty ? DateTime.parse(savedDateTimeString) : DateTime.now();
    bsmList(savedDateTime);

    final bsmMessageString = await SessionStorage().getString(SsKeys.bsmMessage) ?? '';
    bsmState.newBsmC.text = bsmMessageString;
  }

  Future<List<BsmResult>> bsmList(DateTime dt) async {
    final bsmDate = ref.read(bsmDateProvider.notifier);
    bsmDate.state = dt;
    await SessionStorage().setString(SsKeys.bsmDateP, dt.toIso8601String());

    List<BsmResult> bsms = [];
    BsmListUseCase bsmListUsecase = BsmListUseCase();
    BsmListRequest bsmListRequest = BsmListRequest(date: dt);
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
      bsmList.insertBsm(0, r.bsmResult);
    });
    return bsmResult;
  }
}

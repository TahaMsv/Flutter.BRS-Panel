import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/parser.dart';
import '../interfaces/bsm_data_source_interface.dart';
import '../usecases/add_bsm_usecase.dart';
import '../usecases/bsm_list_usecase.dart';
import 'bsm_local_ds.dart';

class BsmRemoteDataSource implements BsmDataSourceInterface {
  final BsmLocalDataSource localDataSource = BsmLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  BsmRemoteDataSource();

  @override
  Future<BsmListResponse> bsmList({required BsmListRequest request}) async {
    Response res = await networkManager.post(request);
    BsmListResponse response = await Parser().pars(BsmListResponse.fromResponse, res);
    return response;
  }

    @override
      Future<AddBSMResponse> addBsm({required AddBSMRequest request}) async {
        Response res = await networkManager.post(request);
        AddBSMResponse response = await Parser().pars(AddBSMResponse.fromResponse, res);
        return response;
      }

}

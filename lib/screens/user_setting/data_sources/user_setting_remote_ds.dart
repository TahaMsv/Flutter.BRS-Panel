import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/constants/apis.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/user_setting_data_source_interface.dart';
import '../usecases/change_pass_usecase.dart';
import '../usecases/upload_avatar_usecase.dart';
import 'user_setting_local_ds.dart';

class UserSettingRemoteDataSource implements UserSettingDataSourceInterface {
  final UserSettingLocalDataSource localDataSource = UserSettingLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  UserSettingRemoteDataSource();

  @override
  Future<UploadAvatarResponse> uploadAvatar({required UploadAvatarRequest request}) async {
    try {
      var header = {"Api-Key": Apis.imageServiceToken};
      final res =
          await networkManager.dioPost(api: Apis.uploadProfileImage, request: await request.toJson(), header: header);
      print("rem 22");
      Response response = Response(status: res.data["ResultCode"], message: res.data["ResultText"], body: null);
      print("rem 24");
      if (response.status != 1) {
        print("rem 26");
        throw ServerException(
            code: response.status, message: response.message, trace: StackTrace.fromString("uploadAvatar"));
      }
      print("rem 29");
      return UploadAvatarResponse.fromResponse(response);
    } catch (e) {
      throw ServerException(message: "Failed Uploading Data", code: -1, trace: StackTrace.fromString("uploadAvatar"));
    }
  }

  @override
  Future<ChangePassResponse> changePass({required ChangePassRequest request}) async {
    Response res = await networkManager.post(request);
    return ChangePassResponse.fromResponse(res);
  }
}

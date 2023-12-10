import '../usecases/change_pass_usecase.dart';
import '../usecases/upload_avatar_usecase.dart';

abstract class UserSettingDataSourceInterface {
  Future<UploadAvatarResponse> uploadAvatar({required UploadAvatarRequest request});
  Future<ChangePassResponse> changePass({required ChangePassRequest request});
}

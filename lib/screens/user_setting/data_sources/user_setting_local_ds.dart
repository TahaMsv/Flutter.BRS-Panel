import 'package:brs_panel/screens/user_setting/usecases/delete_avatar_usecase.dart';

import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/user_setting_data_source_interface.dart';
import '../usecases/change_pass_usecase.dart';
import '../usecases/upload_avatar_usecase.dart';

const String userJsonLocalKey = "UserJson";

class UserSettingLocalDataSource implements UserSettingDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  UserSettingLocalDataSource();

  @override
  Future<UploadAvatarResponse> uploadAvatar({required UploadAvatarRequest request}) {
    throw UnimplementedError();
  }

  @override
  Future<ChangePassResponse> changePass({required ChangePassRequest request}) {
    throw UnimplementedError();
  }

  @override
  Future<UploadAvatarResponse> deleteAvatar({required DeleteAvatarRequest request}) {
    throw UnimplementedError();
  }
}

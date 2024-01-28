import 'package:brs_panel/screens/user_setting/usecases/delete_avatar_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/change_pass_usecase.dart';
import '../usecases/upload_avatar_usecase.dart';

abstract class UserSettingRepositoryInterface {
  Future<Either<Failure, UploadAvatarResponse>> uploadAvatar(UploadAvatarRequest request);

  Future<Either<Failure, DeleteAvatarResponse>> deleteAvatar(DeleteAvatarRequest request);

  Future<Either<Failure, ChangePassResponse>> changePass(ChangePassRequest request);
}

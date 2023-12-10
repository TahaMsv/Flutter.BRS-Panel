import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'data_sources/user_setting_local_ds.dart';
import 'data_sources/user_setting_remote_ds.dart';
import 'interfaces/user_setting_repository_interface.dart';
import 'usecases/change_pass_usecase.dart';
import 'usecases/upload_avatar_usecase.dart';

class UserSettingRepository implements UserSettingRepositoryInterface {
  final UserSettingRemoteDataSource userSettingRemoteDataSource = UserSettingRemoteDataSource();
  final UserSettingLocalDataSource userSettingLocalDataSource = UserSettingLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  UserSettingRepository();

  @override
  Future<Either<Failure, UploadAvatarResponse>> uploadAvatar(UploadAvatarRequest request) async {
    try {
      UploadAvatarResponse uploadAvatarResponse;
      if (await networkInfo.isConnected) {
        uploadAvatarResponse = await userSettingRemoteDataSource.uploadAvatar(request: request);
      } else {
        uploadAvatarResponse = await userSettingLocalDataSource.uploadAvatar(request: request);
      }
      return Right(uploadAvatarResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, ChangePassResponse>> changePass(ChangePassRequest request) async {
    try {
      ChangePassResponse changePassResponse;
      if (await networkInfo.isConnected) {
        changePassResponse = await userSettingRemoteDataSource.changePass(request: request);
      } else {
        changePassResponse = await userSettingLocalDataSource.changePass(request: request);
      }
      return Right(changePassResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}

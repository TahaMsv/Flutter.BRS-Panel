import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/basic_class.dart';
import '../user_setting_repository.dart';

class UploadAvatarUseCase extends UseCase<UploadAvatarResponse, UploadAvatarRequest> {
  UploadAvatarUseCase();

  @override
  Future<Either<Failure, UploadAvatarResponse>> call({required UploadAvatarRequest request}) {
    UserSettingRepository repository = UserSettingRepository();
    return repository.uploadAvatar(request);
  }
}

class UploadAvatarRequest {
  UploadAvatarRequest({required this.imageValue, required this.imageName});

  Uint8List imageValue;
  String imageName;

  Future<Map<String, dynamic>> toJson() async => {
        'ProjectName': "BRS",
        'UserID': BasicClass.username,
        'File': NetworkManager().getImageFileFromString(imageValue, fileName: imageName)
      };
}

class UploadAvatarResponse extends Response {
  UploadAvatarResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory UploadAvatarResponse.fromResponse(Response res) {
    return UploadAvatarResponse(status: res.status, message: res.message);
  }
}

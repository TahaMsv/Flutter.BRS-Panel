import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/basic_class.dart';
import '../user_setting_repository.dart';

class DeleteAvatarUseCase extends UseCase<DeleteAvatarResponse, DeleteAvatarRequest> {
  DeleteAvatarUseCase();

  @override
  Future<Either<Failure, DeleteAvatarResponse>> call({required DeleteAvatarRequest request}) {
    UserSettingRepository repository = UserSettingRepository();
    return repository.deleteAvatar(request);
  }
}

class DeleteAvatarRequest {
  DeleteAvatarRequest({required this.imageValue, required this.imageName});

  Uint8List? imageValue;
  String imageName;

  Future<Map<String, dynamic>> toJson() async => {};
}

class DeleteAvatarResponse extends Response {
  DeleteAvatarResponse({required int status, required String message}) : super(status: status, message: message, body: null);

  factory DeleteAvatarResponse.fromResponse(Response res) {
    return DeleteAvatarResponse(status: res.status, message: res.message);
  }
}

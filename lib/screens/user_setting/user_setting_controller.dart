import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/platform/image_picker.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../core/util/handlers/success_handler.dart';
import 'usecases/change_pass_usecase.dart';
import 'usecases/upload_avatar_usecase.dart';
import 'user_setting_state.dart';

class UserSettingController extends MainController {
  late UserSettingState userSettingState = ref.read(userSettingProvider);

  /// View -------------------------------------------------------------------------------------------------------------

  Future<void> setAvatar() async {
    try {
      final XFile? image = await ImageGetter.pickImageFromGallery();
      if (image == null) throw Exception("No image is picked!");
      final Uint8List imageBytes = await image.readAsBytes();
      return uploadAvatarRequest(imageBytes, image.name);
    } catch (e) {
      print(e.toString());
    }
  }

  void changeTimeZone(Airport a) {
    BasicClass.setAirport(a);
    // List<ListPickerItem<Airport>> items = BasicClass.systemSetting.airportList
    //     .map((e) => ListPickerItem(str: "${e.code} (${e.cityName})", icon: Text(e.strTimeZone ?? ''), item: e))
    //     .toList();
    // items.sort((a, b) => a.item.timeZone - b.item.timeZone);
    // nav.dialog(ListPickerDialog(title: "Timezone", list: items)).then((value) {
    //   if (value != null && value is ListPickerItem<Airport>) {
    //     BasicClass.setTimeZone(value.item);
    //     userSettingState.setState();
    //   }
    // });
  }

  /// Requests ---------------------------------------------------------------------------------------------------------

  Future<void> uploadAvatarRequest(Uint8List imageValue, String imageName) async {
    UploadAvatarRequest request = UploadAvatarRequest(imageValue: imageValue, imageName: imageName);
    UploadAvatarUseCase uploadAvatarUseCase = UploadAvatarUseCase();
    final fOrR = await uploadAvatarUseCase(request: request);
    fOrR.fold((l) => FailureHandler.handle(l, retry: () => uploadAvatarRequest(imageValue, imageName)), (r) async {
      CachedNetworkImage.evictFromCache(BasicClass.profileUrl);
      Future.delayed(const Duration(milliseconds: 100), () {
        userSettingState.setState();
      });
    });
  }

  changePassRequest(String oldPass, String newPass, String newPass2) async {
    ChangePassRequest changePassRequest = ChangePassRequest(oldPassV: oldPass, newPassV: newPass, newPass2V: newPass2);
    ChangePassUseCase changePassUseCase = ChangePassUseCase();
    final fOrR = await changePassUseCase(request: changePassRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Your password changed successfully!"));
      nav.pop();
    });
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
  }
}

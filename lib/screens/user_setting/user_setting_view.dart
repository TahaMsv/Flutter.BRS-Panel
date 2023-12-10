import 'package:brs_panel/widgets/MyDropDown.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/ui.dart';
import '../../core/platform/cached_image.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/CardField.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyButton.dart';
import 'user_setting_controller.dart';
import 'user_setting_state.dart';

class UserSettingView extends StatelessWidget {
  const UserSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [UserListWidget()]),
    );
  }
}

class UserSettingPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();
  static UserSettingController controller = getIt<UserSettingController>();

  const UserSettingPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Container()),
          const SizedBox(width: 12),
          const Expanded(
            flex: 5,
            child: Row(
              children: [
                // const Spacer(),
                // DotButton(
                //     size: 35,
                //     onPressed: () => controller.addUpdateUser(null),
                //     icon: Icons.add,
                //     color: Colors.blueAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserListWidget extends ConsumerWidget {
  const UserListWidget({super.key});

  static UserSettingController controller = getIt<UserSettingController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final UserSettingState state = ref.watch(userSettingProvider);
    double avatarRadius = 18;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // state.updatingAvatar ? SizedBox(width: 70, height: 70, child: Center(child: Spinners.circle)) :
                InkWell(
                  onTap: () => controller.setAvatar(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(avatarRadius),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.blueAccent),
                      width: avatarRadius * 2,
                      height: avatarRadius * 2,
                      child: CachedImage.showProfile(BasicClass.profileUrl),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(BasicClass.userInfo.username.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: CardField(title: "ID", value: "${BasicClass.userSetting.id}")),
                Expanded(child: CardField(title: "Airport", value: BasicClass.userSetting.airport)),
                Expanded(child: CardField(title: "Airline", value: BasicClass.userSetting.al)),
                Expanded(child: CardField(title: "AL-Code", value: BasicClass.userSetting.alCode)),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 200,
              child: MyDropDown<Airport>(
                  label: "TimeZone",
                  items: BasicClass.systemSetting.airportList,
                  onSelect: (a) => a == null ? {} : controller.changeTimeZone(a),
                  value: BasicClass.airport,
                  itemToString: (Airport a) => "${a.code} \t ${a.strTimeZone}"),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  label: "Change Password",
                  onPressed: () => controller.changePasswordDialog(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

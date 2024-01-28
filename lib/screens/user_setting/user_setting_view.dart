import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/constants/abomis_pack_icons.dart';
import '../../core/constants/apis.dart';
import '../../core/constants/ui.dart';
import '../../core/platform/cached_image.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/MyTextField.dart';
import '../login/login_state.dart';
import 'user_setting_controller.dart';
import 'user_setting_state.dart';

class UserSettingView extends StatelessWidget {
  const UserSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
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
  static UserSettingController controller = getIt<UserSettingController>();
  final TextEditingController oldPassC = TextEditingController();
  final TextEditingController newPassC = TextEditingController();
  final TextEditingController repPassC = TextEditingController();

  UserListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserSettingState state = ref.watch(userSettingProvider);
    LoginUser? u = ref.watch(userProvider);
    double avatarRadius = 125;
    return Expanded(
      child: Center(
        child: Container(
          height: 850,
          width: 900,
          decoration: BoxDecoration(border: Border.all(color: MyColors.borderColor), borderRadius: BorderRadius.circular(10.0)),
          margin: const EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 31),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(avatarRadius),
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.blueAccent),
                                width: avatarRadius,
                                height: avatarRadius,
                                child: CachedImage.showImage(BasicClass.profileUrl, iconSize: 50),
                              ),
                            ),
                            PopupMenuButton<int>(
                              itemBuilder: (context) => [
                                const PopupMenuItem(height: 35, value: 1, child: Text("Change Photo", style: TextStyles.style13Black)),
                                const PopupMenuItem(height: 35, value: 2, child: Text("Delete Photo", style: TextStyles.style13Black)),
                              ],
                              color: MyColors.white1,
                              initialValue: 0,
                              onSelected: (value) async {
                                switch (value) {
                                  case 1:
                                    await controller.setAvatar();
                                    break;
                                  case 2:
                                    await controller.deleteAvatar();
                                    break;
                                  default:
                                    {
                                      print("Invalid choice");
                                    }
                                    break;
                                }
                              },
                              offset: const Offset(15, 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(31),
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.blueAccent),
                                  width: 31,
                                  height: 31,
                                  child: const Icon(AbomisIconPack.camera, size: 15, color: MyColors.white1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(u!.username, style: TextStyles.style16Black),
                        const SizedBox(height: 19),
                      ],
                    ),
                    const ProfileDrawerElement(title: "Edit Profile", icon: Icons.person, index: 0),
                    const ProfileDrawerElement(title: "Change Password", icon: AbomisIconPack.lock, index: 1),
                    // const ProfileDrawerElement(title: "Email Verification", icon: AbomisIconPack.email, index: 2),
                    // const ProfileDrawerElement(title: "Phone Verification", icon: Icons.phone_android_rounded, index: 3),
                    // const ProfileDrawerElement(title: "FAQ", icon: Icons.info_outline, index: 4),
                    // const ProfileDrawerElement(title: "Support", icon: Icons.call, isBottomDivider: true, index: 5),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: state.editProfileDrawerIndex == 0
                    ? EditProfileWidget(controller: controller)
                    : state.editProfileDrawerIndex == 1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.person_2),
                                  SizedBox(width: 10),
                                  Text("Change Password", style: TextStyles.styleBold16Black),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Enter your password"),
                                    const SizedBox(height: 5),
                                    MyTextField(controller: oldPassC, labelStyle: const TextStyle(color: MyColors.brownGrey3), isPassword: true),
                                    const SizedBox(height: 20),
                                    const Text("Enter your new password"),
                                    const SizedBox(height: 5),
                                    MyTextField(controller: newPassC, labelStyle: const TextStyle(color: MyColors.brownGrey3), isPassword: true),
                                    const SizedBox(height: 20),
                                    const Text("Please re-enter your new password to confirm"),
                                    const SizedBox(height: 5),
                                    MyTextField(controller: repPassC, labelStyle: const TextStyle(color: MyColors.brownGrey3), isPassword: true),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MyButton(
                                          onPressed: () async => await controller.changePassRequest(oldPassC.text, newPassC.text, repPassC.text),
                                          label: 'Submit',
                                          color: MyColors.darkMint,
                                          child: const Row(
                                            children: [Text('Submit', style: TextStyle(color: Colors.white, fontSize: 14)), SizedBox(width: 20), Icon(Icons.check, color: Colors.white)],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox()
                            ],
                          )
                        : Container(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key, required this.controller});

  final UserSettingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.person_2),
            SizedBox(width: 10),
            Text("Edit Profile", style: TextStyles.styleBold16Black),
          ],
        ),
        const SizedBox(height: 30),
        // Row(
        //   children: [
        //     ClipRRect(
        //       borderRadius: BorderRadius.circular(avatarRadius * 3),
        //       child: Container(
        //         decoration: const BoxDecoration(color: Colors.blueAccent),
        //         width: avatarRadius * 3,
        //         height: avatarRadius * 3,
        //         child: CachedImage.showImage(BasicClass.profileUrl, iconSize: 30),
        //       ),
        //     ),
        //     const SizedBox(width: 20),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         TextButton(
        //           onPressed: () async {
        //             await controller.setAvatar();
        //           },
        //           child: const Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 3), Text("Change Photo")]),
        //         ),
        //         TextButton(
        //           child: const Row(children: [Icon(Icons.delete, size: 18, color: MyColors.red), SizedBox(width: 3), Text("Delete", style: TextStyle(color: MyColors.red))]),
        //           onPressed: () {},
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: MyTextField(label: "Username", labelStyle: TextStyle(color: MyColors.brownGrey3))),
            SizedBox(width: 20),
            Expanded(child: MyTextField(label: "Access Level", labelStyle: TextStyle(color: MyColors.brownGrey3)))
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: MyTextField(label: "Name", labelStyle: TextStyle(color: MyColors.brownGrey3))),
            // SizedBox(width: 20),
            // Expanded(child: MyTextField(label: "Last Name", labelStyle: TextStyle(color: MyColors.brownGrey3)))
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: MyTextField(label: "Default Station", labelStyle: TextStyle(color: MyColors.brownGrey3))),
            SizedBox(width: 20),
            Expanded(child: MyTextField(label: "To City", labelStyle: TextStyle(color: MyColors.brownGrey3)))
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: MyTextField(label: "Email", labelStyle: TextStyle(color: MyColors.brownGrey3))),
            SizedBox(width: 20),
            Expanded(child: MyTextField(label: "Phone", labelStyle: TextStyle(color: MyColors.brownGrey3)))
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            const SizedBox(width: 20),
            MyButton(
              onPressed: () {},
              label: 'Submit',
              color: MyColors.darkMint,
              child: const Row(
                children: [Text('Submit', style: TextStyle(color: Colors.white, fontSize: 14)), SizedBox(width: 20), Icon(Icons.check, color: Colors.white)],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ProfileDrawerElement extends ConsumerStatefulWidget {
  const ProfileDrawerElement({super.key, this.isBottomDivider = false, required this.title, required this.icon, required this.index});

  final bool isBottomDivider;
  final String title;
  final IconData icon;
  final int index;

  @override
  ConsumerState<ProfileDrawerElement> createState() => _ProfileDrawerElementState();
}

class _ProfileDrawerElementState extends ConsumerState<ProfileDrawerElement> {
  @override
  Widget build(BuildContext context) {
    final UserSettingState state = ref.watch(userSettingProvider);
    Color textColor = (widget.index == state.editProfileDrawerIndex ? Colors.white : Colors.black);
    Color bgColor = widget.index == state.editProfileDrawerIndex ? Colors.blue : Colors.white;
    return InkWell(
      onTap: () {
        state.editProfileDrawerIndex = widget.index;
        state.setState();
      },
      child: Column(
        children: [
          const Divider(),
          Container(
            color: bgColor,
            height: 55,
            child: Row(
              children: [const SizedBox(width: 10), Icon(widget.icon, color: textColor, size: 16), const SizedBox(width: 10), Text(widget.title, style: TextStyle(color: textColor))],
            ),
          ),
          if (widget.isBottomDivider) const Divider(),
        ],
      ),
    );
  }
}

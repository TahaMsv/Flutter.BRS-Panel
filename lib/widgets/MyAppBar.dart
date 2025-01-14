import 'package:brs_panel/core/util/basic_class.dart';
import 'package:brs_panel/screens/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/classes/login_user_class.dart';
import '../core/constants/ui.dart';
import '../core/navigation/navigation_service.dart';
import '../core/navigation/route_names.dart';
import '../core/navigation/router.dart';
import '../core/platform/cached_image.dart';
import '../initialize.dart';
import '../screens/login/login_controller.dart';
import 'DotButton.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final router = ref.watch(routerProvider);
        List<RouteNames> routeNames = RouteNames.values.where((e) => BasicClass.userSetting.isAdmin || e != RouteNames.users).toList();
        if (!BasicClass.userSetting.isAdmin) routeNames.removeWhere((element) => false);
        RouteNames? currentRoute = routeNames.firstWhereOrNull((element) => element.path == router.location);
        bool isSubroute = currentRoute == null;
        // print(router.location);
        currentRoute ??= routeNames.lastWhere((element) => router.location.contains("/${element.path}"));
        return Container(
          decoration: const BoxDecoration(color: MyColors.white1, border: Border(bottom: BorderSide(color: MyColors.lineColor))),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: isSubroute
              ? DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DotButton(
                          size: 35,
                          icon: Icons.keyboard_arrow_left_sharp,
                          onPressed: () {
                            NavigationService ns = getIt<NavigationService>();
                            ns.pop();
                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        ...routeNames.where((element) => router.location.split("/").contains(element.name)).map((e) {
                          bool isLast = [...routeNames].where((element) => router.location.split("/").contains(element.name)).toList().last.path == e.path;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0, top: 0),
                                child: TextButton(
                                  onPressed: () {
                                    NavigationService ns = getIt<NavigationService>();
                                    ns.pushNamed(e);
                                  },
                                  child: Text(
                                    e.title,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              if (!isLast) const Icon(Icons.keyboard_arrow_right, color: MyColors.lightIshBlue)
                            ],
                          );
                        }).toList(),
                        const Spacer(),
                        UserIndicatorWidget(),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    IndexedStack(
                      index: 0,
                      children: [
                        const SizedBox(),
                        Row(
                          children: [
                            DotButton(
                              icon: Icons.keyboard_arrow_left_sharp,
                              onPressed: () {
                                NavigationService ns = getIt<NavigationService>();
                                ns.pop();
                              },
                            ),
                            const SizedBox(width: 12),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: routeNames.where((element) => element.isMainRoute).map(
                        (e) {
                          bool selected = currentRoute == e;
                          // if (e.name == RouteNames.users.name && !BasicClass.userSetting.isAdmin) return Container();

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              border: selected ? const Border(bottom: BorderSide(color: MyColors.lightIshBlue, width: 4)) : const Border(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, top: 4),
                              child: TextButton(
                                onPressed: () {
                                  NavigationService ns = getIt<NavigationService>();
                                  ns.pushNamed(e);
                                },
                                child: Text(
                                  e.title,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const Spacer(),
                    UserIndicatorWidget(),
                  ],
                ),
        );
      },
    );
  }
}

class UserIndicatorWidget extends ConsumerWidget {
  UserIndicatorWidget({Key? key}) : super(key: key);
  final LoginController myLoginController = getIt<LoginController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoginUser? u = ref.watch(userProvider);
    ThemeData theme = Theme.of(context);
    // double width = MediaQuery.of(context).sizewidth;
    // double height = MediaQuery.of(context).sizeheight;
    final vp = ref.read(versionProvider);
    double avatarRadius = 18;
    if (u == null) return const SizedBox();
    return Container(
      // width: 300,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (vp != null) Text("Version $vp", style: const TextStyle(color: MyColors.warmGrey, fontSize: 12)),
              const SizedBox(width: 10),
              InkWell(
                // onTap: () => myLoginController.showStimulPreview(),
                onTap: null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(avatarRadius),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.blueAccent),
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    child: CachedImage.showImage(BasicClass.profileUrl),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: myLoginController.goToUserProfile,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Hello, ${u.username}"), Text(ref.watch(selectedServer)?.name ?? "", style: const TextStyle(fontSize: 8))],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: () => myLoginController.logout(), icon: const Icon(Icons.exit_to_app_outlined))
        ],
      ),
    );
  }
}

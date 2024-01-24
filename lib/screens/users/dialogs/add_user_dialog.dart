import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/MyDropDown.dart';
import 'package:brs_panel/widgets/MySegment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/util/basic_class.dart';
import '../../../core/util/handlers/failure_handler.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/MyTextField.dart';
import '../users_controller.dart';

class AddUpdateUserDialog extends StatefulWidget {
  final User? user;

  const AddUpdateUserDialog({Key? key, this.user}) : super(key: key);

  @override
  State<AddUpdateUserDialog> createState() => _AddUpdateUserDialogState();
}

class _AddUpdateUserDialogState extends State<AddUpdateUserDialog> {
  late final bool isEditing;
  UserAccessType userType = UserAccessType.agent;
  final TextEditingController handlingC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();
  final TextEditingController alC = TextEditingController();
  final TextEditingController airportC = TextEditingController();
  late final List<Airport> airportList;
  Airport? selectedAirport;
  late final List<HandlingAccess> handlingList;
  HandlingAccess? selectedHandling;
  bool showPass = false;
  bool changePass = false;
  bool savePass = false;

  @override
  void initState() {
    isEditing = widget.user != null;
    airportList = BasicClass.systemSetting.airportList;
    handlingList = BasicClass.systemSetting.handlingAccess;
    if (widget.user != null) {
      userType = UserAccessType.values.firstWhere((element) => element.id == widget.user!.accessType);
      selectedAirport = BasicClass.getAirportByCode(widget.user!.airport);
      alC.text = widget.user!.al;
      nameC.text = widget.user!.name;
      usernameC.text = widget.user!.username;
      savePass = widget.user!.isSavePassword;
      selectedHandling = BasicClass.getHandlingByID(widget.user!.handlingID);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final NavigationService nav = getIt<NavigationService>();
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 0),
              child: Row(
                children: [
                  Text(isEditing ? "Edit User" : "Add User", style: theme.textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(onPressed: nav.pop, icon: const Icon(Icons.close, color: MyColors.brownGrey)),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: handlingList.isEmpty
                            ? const SizedBox()
                            : MyDropDown<HandlingAccess>(
                                width: 250,
                                label: "Handling",
                                items: handlingList,
                                value: selectedHandling,
                                itemToString: (ha) => ha.name,
                                canClear: true,
                                showType2: true,
                                onSelect: (HandlingAccess? ha) => setState(() => selectedHandling = ha),
                              ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: MySegment<UserAccessType>(
                          height: 48,
                          items: UserAccessType.values.where((element) => element != UserAccessType.admin || BasicClass.userInfo.userSettings.isAdmin).toList(),
                          value: userType,
                          itemToString: (e) => e.label!,
                          onChange: (v) {
                            userType = v;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: MyDropDown<Airport>(
                          width: 250,
                          label: "Airport",
                          items: airportList,
                          value: selectedAirport,
                          itemToString: (ha) => ha.code,
                          canClear: true,
                          showType2: true,
                          onSelect: (Airport? sa) => setState(() => selectedAirport = sa),
                        ),
                      ),

                      // Expanded(
                      //   flex: 1,
                      //   child: DropdownSearch<String>(
                      //     popupProps: PopupProps.menu(
                      //       showSelectedItems: true,
                      //       showSearchBox: true,
                      //       disabledItemFn: (String s) => s.startsWith('I'),
                      //     ),
                      //     items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      //     dropdownDecoratorProps: DropDownDecoratorProps(
                      //
                      //       dropdownSearchDecoration: InputDecoration(
                      //         labelText: "Menu mode",
                      //         hintText: "country in menu mode",
                      //       ),
                      //     ),
                      //     onChanged: print,
                      //     selectedItem: "Brazil",
                      //   )
                      // ),
                      const SizedBox(width: 20),
                      Expanded(
                          child: SizedBox(
                              height: 48,
                              child: MyTextField(
                                label: "AL",
                                controller: alC,
                                inputFormatters: [UpperCaseTextFormatter()],
                              ))),

                      // Expanded(
                      //     child: SizedBox(
                      //   height: 48,
                      //   width: 200,
                      //
                      //   child: MyDropDown<Airport>(
                      //     label: "Airport",
                      //     items: airportList,
                      //     value: selectedAirport,
                      //     itemToString: (sa) => sa.code,
                      //     showType2: true,
                      //     onSelect: (Airport? sa) => setState(() => selectedAirport = sa),
                      //   ),
                      // )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 48, child: MyTextField(label: "Name", controller: nameC)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: MyTextField(label: "Username", controller: usernameC, locked: widget.user != null),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: !isEditing
                            ? SizedBox(
                                height: 48,
                                child: MyTextField(label: isEditing ? 'New Password' : 'Password', controller: passwordC, isPassword: true),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isEditing && changePass)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: MyTextField(label: "New Password", controller: passwordC, isPassword: true),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: MyTextField(label: 'Confirm New Password', controller: confirmPasswordC, isPassword: true),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 12),
                isEditing
                    ? Row(
                        children: [
                          const Text("Change Password"),
                          CupertinoSwitch(value: changePass, onChanged: (v) => setState(() => changePass = v)),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(width: 20),
                const Text("Save Password"),
                CupertinoSwitch(value: savePass, onChanged: (v) => setState(() => savePass = v)),
                const Spacer(),
                MyButton(label: "Cancel", onPressed: nav.pop, color: MyColors.brownGrey5),
                const SizedBox(width: 20),
                MyButton(
                  label: "${widget.user == null ? 'Add' : 'Update'} User",
                  onPressed: () async {
                    final UsersController controller = getIt<UsersController>();
                    User user = User(
                      id: widget.user?.id ?? 0,
                      username: usernameC.text,
                      name: nameC.text,
                      airport: selectedAirport?.code ?? '',
                      al: alC.text,
                      barcodeLength: 10,
                      alCode: "000",
                      waitSecondMin: 3,
                      waitSecondMax: 6,
                      tagOnlyDigit: true,
                      isAdmin: false,
                      handlingID: selectedHandling?.id,
                      isHandlingAdmin: false,
                      isSavePassword: savePass,
                      accessType: userType.id,
                      password: passwordC.text.isEmpty ? null : passwordC.text,
                    );
                    if (isEditing && changePass && passwordC.text != confirmPasswordC.text) {
                      return FailureHandler.handle(ValidationFailure(code: -1, msg: "Passwords do not match! Please enter again.", traceMsg: ""));
                    }
                    await controller.addUpdateUserRequest(user);
                  },
                ),
                const SizedBox(width: 12),
              ],
            )
          ],
        ),
      ),
    );
  }
}

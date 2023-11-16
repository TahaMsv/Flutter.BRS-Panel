import 'package:flutter/material.dart';
import '../../../widgets/MyButton.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../core/classes/server_class.dart';
import '../initialize.dart';
import '../screens/login/login_controller.dart';

class ServerSelectDialog extends StatefulWidget {
  final List<Server> servers;
  final Server? currentServer;
   ServerSelectDialog({Key? key,required this.servers,required this.currentServer}) : super(key: key);

  @override
  State<ServerSelectDialog> createState() => _ServerSelectDialogState();
}

class _ServerSelectDialogState extends State<ServerSelectDialog> {
  final LoginController myLoginController = getIt<LoginController>();

  final NavigationService navigationService = getIt<NavigationService>();

  TextEditingController nameC = TextEditingController();
  Server? tmpServer;
  bool loading = false;

  @override
  void initState() {
    tmpServer = widget.currentServer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.35),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 18),
              const Text("Select Server", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    navigationService.popDialog();
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(height: 1),
          Container(
            height: height/2,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: widget.servers.map((e) {
                      bool isSelected = tmpServer == e;
                      return RadioListTile<Server>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        groupValue: tmpServer,
                        activeColor: theme.primaryColor,
                        title: Text(e.name),
                        value: e,
                        onChanged: (Server? value) {
                          // if(value!=null) {
                          //   LocalDataBase.setServer(value);
                          // }
                          setState(() {
                            tmpServer = value;
                          });

                        },
                      );
                      // return MyCheckBoxButton(
                      //   label: e.name,
                      //   checkBoxAtEnd: true,
                      //   value: isSelected,
                      //   onChanged: (bool? value) {
                      //     if (value ?? false) {
                      //       setState(() {
                      //         tmpServer = e;
                      //       });
                      //     }
                      //   },
                      // );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: Row(
              children: [
                //TextButton(onPressed: () {}, child: const Text("Add")),
                const Spacer(),

                MyButton(
                  onPressed: () => navigationService.popDialog(),
                  label: "Cancel",
                  color: MyColors.greyishBrown,
                  // isFlat: true,
                ),
                const SizedBox(width: 12),
                MyButton(
                  // loading: loading,
                  onPressed: () async {
                    myLoginController.nav.pop(tmpServer);
                    // loading = true;
                    // setState(() {});
                    // await myLoginController.ServerSelect(nameC.text, () {
                    //   navigationService.popDialog(onPop: () {
                    //     SuccessHandler.handle(ServerSuccess(code: 1, msg: "Login Added Successfully"));
                    //   });
                    // });
                    // loading = false;
                    // setState(() {});
                  },
                  label: "Select",
                  color: theme.primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

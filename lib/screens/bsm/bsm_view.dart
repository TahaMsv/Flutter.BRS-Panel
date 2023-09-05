import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/util/basic_class.dart';
import '../../widgets/LoadingListView.dart';
import 'bsm_controller.dart';
import 'bsm_state.dart';

class BsmView extends StatelessWidget {
  static final BsmController myBsmController = getIt<BsmController>();

  const BsmView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            // TextButton(
            //     onPressed: () {
            //       myBsmController.bsmList(DateTime.now());
            //     },
            //     child: const Text("Load")),
            // TextButton(
            //     onPressed: () {
            //       myBsmController.addBsm('''
            //                             BSM
            //                             .V/1LSYZ
            //                             .F/FZ1234/05SEP/DXB/Y
            //                             .N/0141438894001
            //                             .S/Y/14D/C/001//Y/
            //                             .W/K/1/5/
            //                             .P/1LOMBARDO/LEA
            //                             .L/NKSE8
            //                             ENDBSM
            //                             ''');
            //     },
            //     child: const Text("Add")),
            BsmPanelWidget(),
            BsmListWidget()
          ],
        ));
  }
}

class BsmPanelWidget extends ConsumerWidget {
  static final BsmController myBsmController = getIt<BsmController>();

  const BsmPanelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final BsmState state = ref.watch(bsmProvider);
    final bsmList = ref.watch(filteredBsmListProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  maxLines: null,
                  placeholder: "BSM Message",
                  controller: state.newBsmC,
                ),
              ),
              const SizedBox(width: 12),
              MyButton(
                label: "Submit",
                onPressed: () async{
                  await myBsmController.addBsm(state.newBsmC.text);
                },
              ),
              const SizedBox(width: 12),
              DotButton(
                size: 35,
                icon: Icons.refresh,
                onPressed: () {
                  myBsmController.bsmList(DateTime.now());
                },
              )
            ],
          ),
          Divider(height: 12,thickness: 4,),
          Container(

            child: const Row(
              children: [
                Expanded(flex: 1, child: Text("Message ID",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.mainColor),)),
                Expanded(flex: 8, child: Text("BSM Message",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.mainColor))),
                Expanded(flex: 3, child: Text("Response",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.mainColor))),
              ],
            ),
          ),
          Divider(height: 12,thickness: 4,),
        ],
      ),
    );
  }
}

class BsmListWidget extends ConsumerWidget {
  const BsmListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final BsmState state = ref.watch(bsmProvider);
    final bsmList = ref.watch(filteredBsmListProvider);
    return Expanded(
      child: LoadingListView(
          loading: state.loadingBSM,
          child: ListView.builder(
            itemBuilder: (c, i) => BsmResultWidget(
              index: i,
              bsmResult: bsmList[i],
            ),
            itemCount: bsmList.length,
          )),
    );
  }
}

class BsmResultWidget extends StatelessWidget {
  final int index;
  final BsmResult bsmResult;

  BsmResultWidget({Key? key, required this.bsmResult, required this.index}) : super(key: key);
  final BsmController myBsmController = getIt<BsmController>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: index.isEven ? MyColors.evenRow : MyColors.oddRow,
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(bsmResult.messageId.toString())),
          Expanded(flex: 8, child: Text(bsmResult.messageBody)),
          Expanded(flex: 3, child: Text(bsmResult.bsmResultText)),
        ],
      ),
    );
  }
}

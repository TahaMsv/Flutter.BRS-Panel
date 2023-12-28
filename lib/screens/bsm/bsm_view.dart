import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/bsm/data_tables/bsm_data_table.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyButtonPanel.dart';
import 'package:brs_panel/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/classes/bsm_result_class.dart';
import '../../core/constants/share_prefrences_keys.dart';
import '../../core/data_base/web_data_base.dart';
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
    final bsmDate = ref.watch(bsmDateProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: MyTextField(
                  maxLines: null,
                  placeholder: "BSM Message",
                  controller: state.newBsmC,
                  suffixIcon: DotButton(
                    icon: Icons.delete,
                    onPressed: () {
                      state.newBsmC.clear();
                       SessionStorage().setString(SpKeys.bsmMessage, "");
                    },
                  ),
                  onChanged: (v) {
                    SessionStorage().setString(SpKeys.bsmMessage, v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              MyButton(
                label: "Submit",
                onPressed: () async {
                  await myBsmController.addBsm(state.newBsmC.text);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: MyButtonPanel(
                  leftAction: () {
                    ref.read(bsmDateProvider.notifier).update((state) => state.add(const Duration(days: -1)));
                    myBsmController.bsmList(bsmDate);
                  },
                  rightAction: () {
                    ref.read(bsmDateProvider.notifier).update((state) => state.add(const Duration(days: 1)));
                    myBsmController.bsmList(bsmDate);
                  },
                  centerAction: () {},
                  centerWidget: Text(bsmDate.format_ddMMMEEE),
                  leftWidget: const Icon(Icons.chevron_left),
                  rightWidget: const Icon(Icons.chevron_right),
                ),
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
      child: state.loadingBSM
          ? const SpinKitCircle(size: 50, color: MyColors.mainColor)
          : SfDataGrid(
              onQueryRowHeight: (details) {
                return details.getIntrinsicRowHeight(details.rowIndex);
              },
              headerGridLinesVisibility: GridLinesVisibility.both,
              selectionMode: SelectionMode.none,
              shrinkWrapColumns: true,
              // shrinkWrapRows: true,
              // shrinkWrapColumns: false,
              sortingGestureType: SortingGestureType.doubleTap,
              gridLinesVisibility: GridLinesVisibility.vertical,
              allowSorting: true,
              rowHeight: 70,
              headerRowHeight: 35,
              source: BsmDataSource(bsm: bsmList),
              columns: BsmDataTableColumn.values
                  .map(
                    (e) => GridColumn(
                      columnName: e.name,
                      label: Center(child: Text(e.label!)),
                      width: e.width * width,
                    ),
                  )
                  .toList()),
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

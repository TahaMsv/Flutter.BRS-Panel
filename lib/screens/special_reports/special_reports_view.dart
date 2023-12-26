import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/classes/special_report_class.dart';
import 'package:brs_panel/core/platform/spiners.dart';
import 'package:brs_panel/core/util/string_utils.dart';
import 'package:brs_panel/screens/special_reports/special_reports_state.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:brs_panel/widgets/MyFieldPicker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../../core/classes/special_report_data_class.dart';
import '../../core/classes/special_report_param_class.dart';
import '../../core/classes/special_report_param_option_class.dart';
import '../../core/classes/special_report_result_class.dart';
import '../../core/constants/ui.dart';
import '../../core/util/pickers.dart';
import '../../initialize.dart';
import '../../widgets/ButtonPanel.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyCheckBoxButton.dart';
import '../../widgets/MyTImeField.dart';
import '../../widgets/MyTextField.dart';
import '../login/login_controller.dart';
import 'special_reports_controller.dart';

class SpecialReportsView extends StatefulWidget {
  const SpecialReportsView({super.key});

  @override
  State<SpecialReportsView> createState() => _SpecialReportsViewState();
}

class _SpecialReportsViewState extends State<SpecialReportsView> {

  // @override
  // void initState() {
  //   LoginController controller = getIt<LoginController>();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) => controller.retrieveFromLocalStorage());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [
        Expanded(
          child: SpecialReportsParamsWidget(),
        )
      ]),
    );
  }
}

class SpecialReportsParamsWidget extends ConsumerWidget {
  const SpecialReportsParamsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SpecialReportData? spp = ref.watch(specialReportDataProvider);
    final bool loadingSpp = ref.watch(loadingSpecialReportDataProvider);
    if (loadingSpp) return Spinners.loadingSpinnerColor;
    if (spp == null) return Container();
    final SpecialReport? selectedReport = ref.watch(selectedSpecialReportProvider);
    final SpecialReportResult? report = ref.watch(specialReportResultProvider);
    Map<SpecialReportParam, ParamOption> current = ref.watch(paramsDataProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyFieldPicker<SpecialReport>(
                      items: spp.reportList,
                      itemToString: (e) => e.label,
                      label: "Report",
                      value: selectedReport,
                      onChange: getIt<SpecialReportsController>().onSelectReport,
                    ),
                  ),
                  const SizedBox(width: 12),
                  MyButton(
                    height: 48,
                    width: 200,
                    fontSize: 16,
                    label: "Get Report",
                    onPressed: selectedReport == null
                        ? null
                        : () async {
                            await getIt<SpecialReportsController>().getSpecialReportResult();
                          },
                  ),
                  const SizedBox(width: 200),
                  const Expanded(flex: 3, child: SizedBox()),
                ],
              ),
              GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 5),
                  children: selectedReport == null
                      ? []
                      : selectedReport.getParameters.map((e) {
                          final p = spp.parameters.firstWhere((element) => element.id == e);
                          return SpecialReportParamWidget(
                            param: p,
                            onChange: (v) {
                              // Map<SpecialReportParam, ParamOption> current = ref.watch(paramsDataProvider);
                              // print(current.length);
                              current.update(p, (value) => ParamOption(value: v, label: "label"));
                              ref.read(paramsDataProvider.notifier).update((state) => current);
                            },
                          );
                        }).toList()),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
            child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: report == null ? const SizedBox() : SpecialReportResultWidget(report: report),
        ))
      ],
    );
  }
}

class SpecialReportsPanel extends ConsumerStatefulWidget {
  const SpecialReportsPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpecialReportsPanelState();
}

class _SpecialReportsPanelState extends ConsumerState<SpecialReportsPanel> {
  static TextEditingController searchC = TextEditingController();
  static SpecialReportsController controller = getIt<SpecialReportsController>();
  bool showClearButton = false;

  @override
  void initState() {
    showClearButton = searchC.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here ...",
                controller: searchC,
                showClearButton: showClearButton,
                onChanged: (v) {
                  setState(() {
                    showClearButton = searchC.text.isNotEmpty;
                  });
                },
              )),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                const Spacer(),
                DotButton(size: 35, onPressed: () {}, icon: Icons.add, color: Colors.blueAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialReportParamWidget extends StatefulWidget {
  final SpecialReportParam param;
  final void Function(dynamic) onChange;

  const SpecialReportParamWidget({super.key, required this.param, required this.onChange});

  @override
  State<SpecialReportParamWidget> createState() => _SpecialReportParamWidgetState();
}

class _SpecialReportParamWidgetState extends State<SpecialReportParamWidget> {
  DateTime dateVal = DateTime.now();
  TimeOfDay timeVal = TimeOfDay.now();
  TextEditingController numberC = TextEditingController();
  TextEditingController textC = TextEditingController();
  bool checkBoxVal = false;
  ParamOption? selectedOption = null;

  @override
  void initState() {
    numberC.addListener(() {
      widget.onChange(numberC.text);
    });
    textC.addListener(() {
      widget.onChange(numberC.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    numberC.dispose();
    textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.param.getType) {
      case SpecialReportParamTypes.date:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: Row(
            children: [
              Expanded(child: Text(widget.param.label)),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ButtonPanel(
                  rightAction: () async {
                    dateVal = dateVal.add(const Duration(days: 1));
                    widget.onChange(dateVal.formatyyyyMMdd);
                    setState(() {});
                  },
                  leftAction: () async {
                    dateVal = dateVal.add(const Duration(days: -1));
                    widget.onChange(dateVal.formatyyyyMMdd);
                    setState(() {});
                  },
                  centerAction: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? date = await Pickers.pickDate(context, dateVal);
                    dateVal = date ?? dateVal;
                    widget.onChange(date.formatyyyyMMdd);
                    setState(() {});
                  },
                  centerWidget: Text(dateVal.formatddMMMEEE, style: const TextStyle(fontWeight: FontWeight.normal, color: MyColors.black)),
                ),
              ),
            ],
          ),
        );
      case SpecialReportParamTypes.time:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: MyTimeField(
            label: widget.param.label,
            onChange: () async {
              TimeOfDay? time = await Pickers.pickTime(context, timeVal);
              timeVal = time ?? timeVal;
              widget.onChange(time.format_HHmm);
              setState(() {});
            },
            value: timeVal.format_HHmm,
          ),
        );
      case SpecialReportParamTypes.number:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: MyTextField(
            label: widget.param.label,
            controller: numberC,
            inputFormatters: [MyInputFormatter.justNumber],
          ),
        );
      case SpecialReportParamTypes.text:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: MyTextField(
            label: widget.param.label,
            controller: textC,
          ),
        );
      case SpecialReportParamTypes.dropDown:
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final List<SpecialReportParameterOptions> spp = ref.watch(specialReportOptionsProvider);
            final bool loadingParamsOptions = ref.watch(loadingParamsOptionsProvider);
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 12, top: 12),
              child: loadingParamsOptions
                  ? Spinners.loadingSpinnerColor
                  : MyFieldPicker<ParamOption>(
                      itemToString: (ParamOption item) => item.label,
                      hasSearch: (spp.firstWhereOrNull((element) => element.id == widget.param.id)?.options ?? []).length > 5,
                      label: widget.param.label,
                      items: spp.firstWhereOrNull((element) => element.id == widget.param.id)?.options ?? [],
                      value: selectedOption,
                      onChange: (v) {
                        selectedOption = v;
                        widget.onChange(v?.value);
                        setState(() {});
                      },
                    ),
            );
          },
        );
      case SpecialReportParamTypes.checkBox:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.lineColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: MyCheckBoxButton(
            onChanged: (bool? value) {
              checkBoxVal = value!;
              widget.onChange(value);
              setState(() {});
            },
            value: checkBoxVal,
            label: widget.param.label,
          ),
        );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: MyTextField(label: widget.param.label),
    );
  }
}

class SpecialReportResultWidget extends StatefulWidget {
  final SpecialReportResult report;

  /// Creates a screen that demonstrates the TableView widget.
  const SpecialReportResultWidget({super.key, required this.report});

  @override
  State<SpecialReportResultWidget> createState() => _SpecialReportResultWidgetState();
}

class _SpecialReportResultWidgetState extends State<SpecialReportResultWidget> {
  late final ScrollController _verticalController = ScrollController();
  late int _rowCount;
  late int _colCount;
  late List<List<dynamic>> fullTable;

  @override
  void initState() {
    _rowCount = widget.report.dataRows.length + 1;
    _colCount = widget.report.dataHeaders.length;
    fullTable = widget.report.dataRows;
    fullTable.insert(0, widget.report.dataHeaders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableView.builder(
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      verticalDetails: ScrollableDetails.vertical(controller: _verticalController),
      cellBuilder: _buildCell,
      columnCount: _colCount,
      columnBuilder: _buildColumnSpan,
      rowCount: _rowCount,
      rowBuilder: _buildRowSpan,
    );
  }

  Widget _buildCell(BuildContext context, TableVicinity vicinity) {
    // List<List<dynamic>> fullTable = widget.report.dataRows;
    // fullTable.insert(0, widget.report.dataHeaders);
    // print(fullTable);
    const TextStyle headersStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white);
    const TextStyle dateStyles = TextStyle(fontSize: 12);
    String data = "${fullTable[vicinity.row][vicinity.column]}";
    if (data.trim() == "null") {
      data = "-";
    }
    if (vicinity.row == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        color: MyColors.mainColor.withOpacity(0.8),
        child: Center(child: Text(data, style: headersStyle)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Center(
          child: Text(
        data,
        style: dateStyles,
      )),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(),
      ),
    );
    return TableSpan(
      foregroundDecoration: decoration,
      extent: const FixedTableSpanExtent(120),
      // onEnter: (_) => print('Entered column $index'),
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) => t.onTap = () => print('Tap column $index'),
        ),
      },
    );
  }

  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index.isEven ? MyColors.evenRow : MyColors.oddRow,
      border: const TableSpanBorder(
        trailing: BorderSide(
          width: 3,
        ),
      ),
    );
    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FixedTableSpanExtent(50),
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) => t.onTap = () => print('Tap row $index'),
        ),
      },
    );

    switch (index % 3) {
      case 0:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(50),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) => t.onTap = () => print('Tap row $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(65),
          cursor: SystemMouseCursors.click,
        );
      case 2:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.15),
        );
    }
    throw AssertionError('This should be unreachable, as every index is accounted for in the switch clauses.');
  }
}

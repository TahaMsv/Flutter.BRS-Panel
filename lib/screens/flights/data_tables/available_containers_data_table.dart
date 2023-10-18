import 'package:brs_panel/core/classes/tag_container_class.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/DotButton.dart';

enum AvailableContainerDataTableColumn {
  id,
  name,
  actions
}

extension FlightDataTableColumnDetails on AvailableContainerDataTableColumn {
  double get width {
    switch (this) {
      case AvailableContainerDataTableColumn.name:
        return 0.65;
      case AvailableContainerDataTableColumn.actions:
        return 0.28;
      case AvailableContainerDataTableColumn.id:
        return 0.17;
    }
  }
  String get label {
    switch (this) {
      case AvailableContainerDataTableColumn.actions:
        return "";
      default :
        return name;
    }
  }
}

class AvailableContainerDataSource extends DataGridSource {
  late final List<TagContainer> _dataList;
  final Future<void> Function(TagContainer) onAdd;

  AvailableContainerDataSource({required List<TagContainer> cons,required this.onAdd}) {
    _dataList = cons;
    _cons = cons
        .map<DataGridRow>(
          (e) => DataGridRow(
        cells: [
          DataGridCell<int>(columnName: AvailableContainerDataTableColumn.id.name, value:cons.length - cons.indexOf(e)),
          DataGridCell<String>(columnName: AvailableContainerDataTableColumn.name.name, value: e.code.trim()),
          DataGridCell<String>(columnName: AvailableContainerDataTableColumn.actions.name, value: ''),
        ],
      ),
    )
        .toList();
  }

  List<DataGridRow> _cons = [];

  @override
  List<DataGridRow> get rows => _cons;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final TagContainer con = _dataList[index];
    return DataGridRowAdapter(
        color: index.isEven?MyColors.evenRow:MyColors.oddRow,
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == AvailableContainerDataTableColumn.id.name) {
            return Container(
              alignment: Alignment.center,
              child: Text("${dataGridCell.value}"),
            );
          }
          if (dataGridCell.columnName == AvailableContainerDataTableColumn.name.name) {
            return Row(
              children: [
                const SizedBox(width: 8),
                con.getImg,
                const SizedBox(width: 8),
                Text(con.code, style: TextStyles.styleBold16Black),
              ],
            );
          }
          if (dataGridCell.columnName == AvailableContainerDataTableColumn.actions.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DotButton(
                    icon: Icons.add,
                    color: Colors.blueAccent,
                    onPressed: (con.tagCount ?? 0) > 0 ? null : ()async{
                      await onAdd(con);
                    },
                  )
                ],
              ),
            );
          }
          return Container();
        }).toList());
  }
}


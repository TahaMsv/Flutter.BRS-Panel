
import 'package:brs_panel/core/classes/tag_container_class.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/constants/ui.dart';
import '../../../initialize.dart';
import '../../../widgets/DotButton.dart';

enum AssignedContainerDataTableColumn {
  id,
  name,
  position,
  tagCount,
  destList,
  classTypes,
  actions
}

extension FlightDataTableColumnDetails on AssignedContainerDataTableColumn {
  double get width {
    switch (this) {
      case AssignedContainerDataTableColumn.name:
        return 0.23;
      case AssignedContainerDataTableColumn.position:
        return 0.1;
      case AssignedContainerDataTableColumn.tagCount:
        return 0.1;
      case AssignedContainerDataTableColumn.destList:
        return 0.2;
      case AssignedContainerDataTableColumn.classTypes:
        return 0.22;
      case AssignedContainerDataTableColumn.actions:
        return 0.06;
      case AssignedContainerDataTableColumn.id:
        return 0.08;
    }
  }
  String get label {
    switch (this) {
      case AssignedContainerDataTableColumn.actions:
        return "";
      default :
        return name;
    }
  }
}

class AssignedContainerDataSource extends DataGridSource {
  late final List<TagContainer> _dataList;
  final Function(TagContainer) onDelete;

  AssignedContainerDataSource({required List<TagContainer> cons,required this.onDelete}) {
    _dataList = cons;
    _cons = cons
        .map<DataGridRow>(
          (e) => DataGridRow(
        cells: [
          DataGridCell<int>(columnName: AssignedContainerDataTableColumn.id.name, value:cons.length - cons.indexOf(e)),
          DataGridCell<String>(columnName: AssignedContainerDataTableColumn.name.name, value: e.title),
          DataGridCell<int>(columnName: AssignedContainerDataTableColumn.position.name, value: 1),
          DataGridCell<String>(columnName: AssignedContainerDataTableColumn.tagCount.name, value: e.from),
          DataGridCell<String>(columnName: AssignedContainerDataTableColumn.destList.name, value: e.destList),
          DataGridCell<String>(columnName: AssignedContainerDataTableColumn.classTypes.name, value: e.classList),
          DataGridCell<String>(columnName: AssignedContainerDataTableColumn.actions.name, value: ''),
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
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.id.name) {
            return Container(
              alignment: Alignment.center,
              child: Text("${dataGridCell.value}"),
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.name.name) {
            return Row(
              children: [
                const SizedBox(width: 8),
                con.getImg,
                const SizedBox(width: 8),
                Text(con.code, style: TextStyles.styleBold16Black),
              ],
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.position.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(con.getPosition!.title,style: TextStyle(color: con.getPosition!.getColor,fontWeight: FontWeight.bold),),
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.tagCount.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(con.tagCount.toString()),
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.destList.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text("(${con.destination})",style: const TextStyle(fontWeight: FontWeight.bold),),
                  Text(con.dests.where((element) => element!=con.destination).join(", ")),
                ],
              ),
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.classTypes.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(con.classList??'-'),
            );
          }
          if (dataGridCell.columnName == AssignedContainerDataTableColumn.actions.name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DotButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: (con.tagCount ?? 0) > 0 ? null : ()async{
                     await onDelete(con);
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


class AssignedContainerDataTableColumnSizer extends ColumnSizer {

}
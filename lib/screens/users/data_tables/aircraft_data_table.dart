import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/user_class.dart';
import '../../../initialize.dart';
import '../users_controller.dart';

enum UserDataTableColumn {
  username,
  name,
  airline,
  airport,
  actions,
}

extension UserDataTableColumnDetails on UserDataTableColumn {
  double get width {
    switch (this) {
      case UserDataTableColumn.username:
        return 0.3;
      case UserDataTableColumn.name:
        return 0.3;
      case UserDataTableColumn.airline:
        return 0.2;
      case UserDataTableColumn.airport:
        return 0.1;
      case UserDataTableColumn.actions:
        return 0.1;
    }
  }
}

class UserDataSource extends DataGridSource {
  late final List<User> _dataList;
  late final UsersController usersController = getIt<UsersController>();

  UserDataSource({required List<User> users}) {
    _dataList = users;
    _users = users
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: UserDataTableColumn.username.name, value: e.username),
            DataGridCell<String>(columnName: UserDataTableColumn.name.name, value: e.name),
            DataGridCell<String>(columnName: UserDataTableColumn.airline.name, value: e.alCode),
            DataGridCell<String>(columnName: UserDataTableColumn.airport.name, value: e.airport),
            DataGridCell<String>(columnName: UserDataTableColumn.actions.name, value: ""),
          ]),
        )
        .toList();
  }

  List<DataGridRow> _users = [];

  @override
  List<DataGridRow> get rows => _users;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    final User f = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == UserDataTableColumn.username.name) {
        return Container(padding: const EdgeInsets.only(left: 12), alignment: Alignment.centerLeft, child: Text(f.username));
      }
      if (dataGridCell.columnName == UserDataTableColumn.name.name) {
        return Container(padding: const EdgeInsets.only(left: 12), alignment: Alignment.centerLeft, child: Text(f.name));
      }
      if (dataGridCell.columnName == UserDataTableColumn.airline.name) {
        return Align(alignment: Alignment.center, child: Text("${f.al}-${f.alCode}"));
      }
      if (dataGridCell.columnName == UserDataTableColumn.airport.name) {
        return Align(alignment: Alignment.center, child: Text(f.airport));
      }
      if (dataGridCell.columnName == UserDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerRight,
          child: DotButton(
            icon: Icons.edit,
            onPressed: () {
              UsersController usersController = getIt<UsersController>();
              usersController.addUpdateUser(f);
            },
          ),
        );
      }
      return Container();
    }).toList());
  }
}

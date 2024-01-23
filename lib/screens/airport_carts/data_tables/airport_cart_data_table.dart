import 'package:brs_panel/core/constants/ui.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/classes/airport_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../initialize.dart';
import '../../../widgets/DotButton.dart';
import '../../../widgets/MyButton.dart';
import '../airport_carts_controller.dart';

enum AirportCartDataTableColumn {
  // id,
  code,
  title,
  assignedFlight,
  closedTime,
  tagTypes,
  actions,
}

extension AirportCartDataTableColumnDetails on AirportCartDataTableColumn {
  double get width {
    switch (this) {
      case AirportCartDataTableColumn.actions:
        return 0.15;
      case AirportCartDataTableColumn.title:
        return 0.15;
      case AirportCartDataTableColumn.tagTypes:
        return 0.35;
      case AirportCartDataTableColumn.assignedFlight:
        return 0.15;
      default:
        return 0.1;
    }
  }

  String get appropriateName {
    switch (this) {
      case AirportCartDataTableColumn.code:
        return "Code";
      case AirportCartDataTableColumn.title:
        return "Title";
      case AirportCartDataTableColumn.tagTypes:
        return "Tag Types";
      case AirportCartDataTableColumn.assignedFlight:
        return "Assigned Flight";
      case AirportCartDataTableColumn.closedTime:
        return "Closed Time";
      case AirportCartDataTableColumn.actions:
        return "Actions";
    }
  }

}

class AirportCartDataSource extends DataGridSource {
  late final List<TagContainer> _dataList;
  late final AirportCartsController airportCartsController = getIt<AirportCartsController>();

  AirportCartDataSource({required List<TagContainer> carts}) {
    _dataList = carts;
    _carts = carts
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              // DataGridCell<String>(columnName: AirportCartDataTableColumn.id.name, value: e.id.toString()),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.code.name, value: e.code),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.title.name, value: e.title),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.assignedFlight.name, value: e.al),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.closedTime.name, value: e.closedTime),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.tagTypes.name, value: e.al),
              DataGridCell<String>(columnName: AirportCartDataTableColumn.actions.name, value: ''),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _carts = [];

  @override
  List<DataGridRow> get rows => _carts;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int index = rows.indexOf(row);
    TagContainer cart = _dataList[index];
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      // if (dataGridCell.columnName == AirportCartDataTableColumn.id.name) {
      //   return Container(alignment: Alignment.center, child: Text(cart.id.toString()));
      // }
      if (dataGridCell.columnName == AirportCartDataTableColumn.code.name) {
        return Container(alignment: Alignment.center, child: Text(cart.code));
      }
      if (dataGridCell.columnName == AirportCartDataTableColumn.title.name) {
        // return Container(alignment: Alignment.center, child: Text(cart.title.toString()));
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            cart.getImgMini,
            const SizedBox(width: 8),
            Text(cart.code, style: TextStyles.styleBold16Black),
          ],
        );
      }

      if (dataGridCell.columnName == AirportCartDataTableColumn.assignedFlight.name) {
        return Container(alignment: Alignment.center, child: Text((cart.al ?? "") + (cart.flnb ?? "")));
      }

      if (dataGridCell.columnName == AirportCartDataTableColumn.closedTime.name) {
        return Container(alignment: Alignment.center, child: Text(cart.closedTime ?? ""));
      }
      if (dataGridCell.columnName == AirportCartDataTableColumn.tagTypes.name) {
        return Container(padding: const EdgeInsets.symmetric(horizontal: 12), alignment: Alignment.centerLeft, child: cart.allowedTagTypesWidget);
      }

      if (dataGridCell.columnName == AirportCartDataTableColumn.actions.name) {
        return Container(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // MyButton(
              //   onPressed: () {},
              //   height: 25,
              //   label: 'Show barcode',
              // ),
              // const SizedBox(width: 12),
              DotButton(
                icon: Icons.edit,
                size: 25,
                onPressed: () {
                  airportCartsController.updateCart(cart);
                },
              ),
              const SizedBox(width: 12),
              DotButton(
                icon: Icons.delete,
                size: 25,
                onPressed: () async => await airportCartsController.deleteCart(cart),
                color: Colors.red,
              ),
            ],
          ),
        );
      }
      return Container();
    }).toList());
  }
}

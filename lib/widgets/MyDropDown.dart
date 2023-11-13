import 'package:brs_panel/core/constants/ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyDropDown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T)? itemToString;
  final void Function(T?) onSelect;
  final String? label;
  final T? value;
  final bool canClear;
  final bool showType2;

  const MyDropDown({
    Key? key,
    required this.items,
    this.itemToString,
    required this.onSelect,
    this.label,
    required this.value,
    this.canClear = false,
    this.showType2 = false,
  }) : super(key: key);

  @override
  State<MyDropDown<T>> createState() => _MyDropDownState<T>();
}

class _MyDropDownState<T> extends State<MyDropDown<T>> {
  TextEditingController valueC = TextEditingController();

  @override
  void initState() {
    valueC.text = widget.value == null ? "" : widget.itemToString?.call(widget.value as T) ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showType2) {
      return DropdownButton2<T>(
        hint: Text(widget.label ?? 'Select Item', style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        dropdownSearchData: const DropdownSearchData(),
        items: widget.items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(widget.itemToString?.call(item) ?? item.toString(), style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
        value: widget.value,
        onChanged: widget.onSelect,
        underline: Container(),
        buttonStyleData: ButtonStyleData(
            overlayColor: MaterialStateProperty.resolveWith((states) => Colors.white),
            height: 40,
            padding: const EdgeInsets.only(left: 10),
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor), color: Colors.white)),
        menuItemStyleData:
            MenuItemStyleData(overlayColor: MaterialStateProperty.resolveWith((states) => Colors.white), height: 40),
        dropdownStyleData: const DropdownStyleData(maxHeight: 140, decoration: BoxDecoration(color: Colors.white)),
      );
    }
    return Theme(
      data: ThemeData(
        visualDensity: const VisualDensity(horizontal: 4, vertical: -4),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(fontSize: 11),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 8),
            border: MaterialStateOutlineInputBorder.resolveWith(
              (states) {
                Color borderColor = MyColors.black;
                double borderWidth = 1;
                if (states.isEmpty) return const OutlineInputBorder(borderSide: BorderSide(color: Colors.black26));
                if (states.contains(MaterialState.disabled)) {
                  borderColor = MyColors.greyBG;
                  borderWidth = 1;
                  return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                }
                if (states.contains(MaterialState.focused)) {
                  borderColor = MyColors.boardingBlue;
                  borderWidth = 2;
                  return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                }
                if (states.contains(MaterialState.hovered)) {
                  borderColor = MyColors.black1;
                  borderWidth = 1.5;
                  return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                }
                return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
              },
            ),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownMenu<T>(
              controller: valueC,
              menuStyle: const MenuStyle(
                  maximumSize: null,
                  minimumSize: null,
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity(horizontal: 4)),
              menuHeight: 150,
              // width: double.infinity,
              initialSelection: widget.value,
              trailingIcon: !widget.canClear
                  ? Container()
                  : GestureDetector(child: const Icon(Icons.clear), onTap: () => valueC.clear()),
              enableFilter: true,
              label: widget.label == null ? null : Text(widget.label!),
              dropdownMenuEntries: widget.items
                  .map((e) => DropdownMenuEntry<T>(value: e, label: widget.itemToString?.call(e) ?? e.toString()))
                  .toList(),
              onSelected: widget.onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

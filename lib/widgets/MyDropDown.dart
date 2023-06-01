import 'package:brs_panel/core/constants/ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyDropDown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T)? itemToString;
  final void Function(T?) onSelect;
  final String? label;
  final T? value;

  const MyDropDown({Key? key, required this.items, this.itemToString, required this.onSelect, this.label, required this.value}) : super(key: key);

  @override
  State<MyDropDown<T>> createState() => _MyDropDownState<T>();
}

class _MyDropDownState<T> extends State<MyDropDown<T>> {
  TextEditingController valueC = TextEditingController();

  @override
  void initState() {
    valueC.text = widget.value == null ? "" : widget.itemToString?.call(widget.value!) ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<T>(
      hint: Text(
        'Select Item',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).hintColor,
        ),
      ),
      dropdownSearchData: DropdownSearchData(),
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  widget.itemToString?.call(item) ?? item.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      value: widget.value,
      onChanged: widget.onSelect,
      buttonStyleData: ButtonStyleData(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.white),
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.lineColor),
          color: Colors.white
        )
        // width: 140,
      ),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.white),
        height: 40,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 140,
        decoration: BoxDecoration(
          color: Colors.white
        )
      ),
    );
    return Theme(
      data: ThemeData(
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(fontSize: 11),
          inputDecorationTheme: InputDecorationTheme(
            // isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: MaterialStateOutlineInputBorder.resolveWith(
              (states) {
                Color borderColor = MyColors.black;
                double borderWidth = 1;
                // if (_errorMsg != null) {
                //   borderColor = MyColors.red;
                //   borderWidth = 2;
                //   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                // }
                if (states.isEmpty) return const OutlineInputBorder(borderSide: BorderSide(color: Colors.black26));
                if (states.contains(MaterialState.disabled)) {
                  borderColor = MyColors.greyBG;
                  borderWidth = 1;
                  return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                }
                // if (states.contains(MaterialState.error) || _errorMsg != null) {
                //   borderColor = MyColors.red;
                //   borderWidth = 2;
                //   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
                // }
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
          // menuStyle: MenuStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownMenu<T>(
              controller: valueC,
              menuHeight: 150,
              // width: 4000,
              initialSelection: widget.value,
              trailingIcon: GestureDetector(
                child: const Icon(Icons.clear),
                onTap: () {
                  valueC.clear();
                  // widget.onSelect(null);
                },
              ),
              // selectedTrailingIcon: IconButton(icon: const Icon(Icons.clear),onPressed: (){
              //   widget.onSelect(null);
              // },),
              // enableSearch: true,
              enableFilter: true,
              label: widget.label == null ? null : Text(widget.label!),
              dropdownMenuEntries: widget.items.map((e) => DropdownMenuEntry<T>(value: e, label: widget.itemToString?.call(e) ?? e.toString())).toList(),
              onSelected: widget.onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

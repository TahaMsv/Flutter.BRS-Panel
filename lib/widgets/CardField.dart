import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/constants/ui.dart';

class CardField extends StatelessWidget {
  final String title;
  final String value;
  final String? titleSuffix;
  final Color valueColor;
  final double scale;
  final NumberFormat? valueFormatter;
  final bool rightAlight;
  final Widget? valueWidget;
  final EdgeInsetsGeometry? widgetPadding;
  final TextStyle? valueStyle;

  const CardField(
      {Key? key, required this.title, this.valueFormatter, this.value = "", this.titleSuffix, this.valueWidget, this.rightAlight = false, this.valueColor = MyColors.black, this.widgetPadding, this.valueStyle, this.scale = 1.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: rightAlight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: rightAlight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: MyColors.brownGrey, fontSize: 12 * scale)),
            Text(titleSuffix == null ? "" : "  $titleSuffix", style: TextStyle(color: Colors.red, fontSize: 12 * scale, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 2),
        valueWidget != null
            ? Padding(
                padding: widgetPadding ?? EdgeInsets.symmetric(vertical: 4),
                child: valueWidget,
              )
            : Text(valueFormatter == null ? value : formatValue(valueFormatter!, value), overflow: TextOverflow.ellipsis, style: valueStyle ?? TextStyle(color: valueColor, fontSize: 16 * scale, fontWeight: FontWeight.w600)),
      ],
    );
  }

  String formatValue(NumberFormat formatter, String value) {
    if (double.tryParse(value) == null) {
      return value;
    } else {
      String formatted = formatter.format(double.tryParse(value));
      return formatted;
    }
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1,this.width = 10, this.color = Colors.black})
      : super(key: key);
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Path customPath = Path()
      ..moveTo(0, 0)
      ..lineTo(width, height);

    return DottedBorder(
      customPath: (size) => customPath, // PathBuilder
      color: Colors.indigo,
      dashPattern: [2, 2],
      strokeWidth: 1,
      child: Container(
        height: width,
        width: height,
      ),
    );
  }
}
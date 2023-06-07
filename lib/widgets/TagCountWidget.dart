import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../core/classes/user_class.dart';

class TagCountWidget extends StatelessWidget {
  final PositionData position;
  final Color color;

  const TagCountWidget({Key? key, required this.position, this.color = MyColors.checkinGreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Position pos = BasicClass.systemSetting.positions.firstWhere((element) => element.id==position.id);
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.4), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Text(pos.title,style: const TextStyle(fontSize: 12),),
          const SizedBox(width: 12),
          ClipPath(
            clipper: CounterClipper(),
            child: Container(
              constraints: const BoxConstraints(minWidth: 30),
              padding: const EdgeInsets.only(left: 8,right: 4),
              alignment: Alignment.center,
              height: 24,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(0)),
              child: Text(position.tagCount.toString(),style: const TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterClipper extends CustomClipper<Path> {
  double _degreeToRadians(num degree) {
    return (degree * pi) / 180.0;
  }
  @override
  getClip(Size size) {
    double x = size.width;
    double y = size.height;
    double r = y/2;
    double m = 4;

    Path p =  Path();
    p.moveTo(x-r+m, 0);
    p.arcToPoint(Offset(x, y/2),radius: Radius.circular(r));
    p.arcToPoint(Offset(x-r, y),radius: Radius.circular(r));
    p.lineTo(r+m, y);
    p.arcToPoint(Offset(0+m, y/2),radius: Radius.circular(r));
    p.arcToPoint(Offset(r, 0),radius: Radius.circular(r));

    p.addPath(getTriangle(const Size(8,16)), Offset(8, r-8));

    return p;
  }

  Path getTriangle(Size size) {
    double x = size.width;
    double y = size.height;

    final path = Path();
    path.moveTo(x-8, 0);
    path.lineTo(x-8, y);
    path.arcToPoint(Offset(0-8,y/2),radius: const Radius.circular(0),clockwise: true);
    path.arcToPoint(Offset(x-8, 0),radius: const Radius.circular(0));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }

}
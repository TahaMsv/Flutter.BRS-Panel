import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../core/classes/user_class.dart';

class TagCountWidget extends StatelessWidget {
  // final PositionData position;
  final Position position;
  final Color color;
  final int count;
  final List<PositionSection> sections;

  const TagCountWidget({Key? key, required this.position, required this.count, this.color = MyColors.checkinGreen, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Position pos = BasicClass.systemSetting.positions.firstWhere((element) => element.id == position.id);
    final c = count == 0 ? Colors.grey.withOpacity(0.4) : color;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30,
            // padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 2,color: pos.getColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pos.title,
                  style: const TextStyle(fontSize: 12),
                ),
                // const SizedBox(width: 12),
                // ClipPath(
                //   clipper: CounterClipper(),
                //   child: Container(
                //     constraints: const BoxConstraints(minWidth: 30),
                //     padding: const EdgeInsets.only(left: 8, right: 4),
                //     alignment: Alignment.center,
                //     height: 24,
                //     decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(0)),
                //     child: Text(
                //       count.toString(),
                //       style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: sections
                  .where((element) => element.count != 0 && element.offset == 1)
                  .map(
                    (e) => Container(
                      height: 18,
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                      child: Center(
                        child: Text(
                          e.count.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: sections.where((element) =>element.count!=0 &&  element.offset==3)
                  .map(
                    (e) => Container(
                  height: 18,
                  margin: const EdgeInsets.only(left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                  child: Center(
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: sections.where((element) =>element.count!=0 && element.offset==4)
                  .map(
                    (e) => Container(
                  height: 18,
                  margin: const EdgeInsets.only(left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                  child: Center(
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: sections.where((element) =>element.count!=0 && element.offset==6)
                  .map(
                    (e) => Container(
                  height: 18,
                  margin: const EdgeInsets.only(left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                  child: Center(
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sections.where((element) =>element.count!=0 && element.offset==5)
                  .map(
                    (e) => Container(
                  height: 18,
                  margin: const EdgeInsets.only(left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                  child: Center(
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sections.where((element) =>element.count!=0 && element.offset==2)
                  .map(
                    (e) => Container(
                  height: 18,
                  margin: const EdgeInsets.only(left: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: e.getColor, borderRadius: BorderRadius.circular(0), border: Border.all(width: 1, color: Colors.white)),
                  child: Center(
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
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
    double r = y / 2;
    double m = 4;

    Path p = Path();
    p.moveTo(x - r + m, 0);
    p.arcToPoint(Offset(x, y / 2), radius: Radius.circular(r));
    p.arcToPoint(Offset(x - r, y), radius: Radius.circular(r));
    p.lineTo(r + m, y);
    p.arcToPoint(Offset(0 + m, y / 2), radius: Radius.circular(r));
    p.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

    p.addPath(getTriangle(const Size(8, 16)), Offset(8, r - 8));

    return p;
  }

  Path getTriangle(Size size) {
    double x = size.width;
    double y = size.height;

    final path = Path();
    path.moveTo(x - 8, 0);
    path.lineTo(x - 8, y);
    path.arcToPoint(Offset(0 - 8, y / 2), radius: const Radius.circular(0), clockwise: true);
    path.arcToPoint(Offset(x - 8, 0), radius: const Radius.circular(0));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }
}

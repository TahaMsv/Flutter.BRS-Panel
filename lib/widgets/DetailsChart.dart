import 'package:brs_panel/core/constants/ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/classes/flight_class.dart';
import '../core/classes/flight_details_class.dart';
import '../core/classes/user_class.dart';

class DetailsChart extends StatefulWidget {
  final List<Position> posList;
  final FlightDetails details;

  const DetailsChart({super.key, required this.details, required this.posList});

  @override
  State<StatefulWidget> createState() => _PieChart2State();
}

class _PieChart2State extends State<DetailsChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(

                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 100,
                  sections: showingSections(widget.details, widget.posList),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.posList.map((e) => Indicator(color: e.getColor, text: e.title, isSquare: false)).toList(),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(FlightDetails details, List<Position> posList) {
    return posList.map((e) {
      final isTouched = posList.indexOf(e) == touchedIndex;
      double value = 100 * details.tagList.where((element) => element.currentPosition == e.id).length / details.tagList.length;
      final radius = isTouched ? 20.0 : 10.0;
      final fontSize = isTouched ? 25.0 : 14.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 0)];
      return PieChartSectionData(
        color: e.getColor,
        value: value,
        title: '${value.toStringAsFixed(2)}%',
        titlePositionPercentageOffset: -3,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: MyColors.black1.withOpacity(0.5),
          shadows: shadows,
        ),
      );
    }).toList();

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 0)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: MyColors.boardingBlue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.black1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: MyColors.oceanGreen,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.black1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: MyColors.pinkishGrey,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.black1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: MyColors.checkinGreen,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyColors.black1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

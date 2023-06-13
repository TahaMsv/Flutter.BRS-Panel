import 'package:brs_panel/core/constants/ui.dart';
import 'package:brs_panel/core/util/basic_class.dart';
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Exception Status",
                style: TextStyles.styleBold16Grey,
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 28,
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
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                // direction: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.posList
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Indicator(color: e.getColor, text: e.title, isSquare: false, size: 12, fontSize: 13),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(FlightDetails details, List<Position> posList) {
    return posList.map((e) {
      final isTouched = posList.indexOf(e) == touchedIndex;
      // double value = 100 * details.tagList.where((element) => element.currentPosition == e.id).length / details.tagList.length;
      double value =  details.tagList.where((element) => element.currentPosition == e.id).length *1.0;
      final radius = isTouched ? 20.0 : 10.0;
      final fontSize = isTouched ? 25.0 : 14.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 0)];
      return PieChartSectionData(
        color: e.getColor,
        value: value,
        title: value.toStringAsFixed(0),
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

  }
}

class DetailsLineChart extends StatefulWidget {
  final List<Position> posList;
  final FlightDetails details;

  const DetailsLineChart({super.key, required this.details, required this.posList});

  @override
  State<StatefulWidget> createState() => _LineChart2State();
}

class _LineChart2State extends State<DetailsLineChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 3,
                child: Column(
                  children: [
                    const Text(
                      "Exception Status",
                      style: TextStyles.styleBold16Grey,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Row(
                              children: <Widget>[
                                ...BasicClass.systemSetting.exceptionStatusList
                                    .where((e) => widget.details.tagList.where((element) => element.exceptionStatusID == e.id).isNotEmpty)
                                    .map(
                                      (e) {
                                        int val =  ((widget.details.tagList.where((element) => element.exceptionStatusID == e.id).length/widget.details.tagList.length)*100).floor();
                                        return Expanded(
                                        flex: val,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            e.title,
                                            // val.toString(),
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      );
                                      },
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Row(
                              children: <Widget>[
                                // Expanded(flex:widget.details.tagList.where((element) => element.exceptionStatusID==-1).length,child: Column(
                                //   children: [
                                //     const Text("Normal",style: TextStyle(fontSize: 11),),
                                //     Container(height: 10,color:Colors.red,),
                                //   ],
                                // ),),
                                ...BasicClass.systemSetting.exceptionStatusList
                                    .where((e) => widget.details.tagList.where((element) => element.exceptionStatusID == e.id).isNotEmpty)
                                    .map(
                                      (e) => Expanded(
                                        flex: widget.details.tagList.where((element) => element.exceptionStatusID == e.id).length,
                                        child: Stack(
                                          children: [
                                            // Text(
                                            //   e.title,
                                            //   style: const TextStyle(fontSize: 11),
                                            // ),
                                            // const SizedBox(height: 4),
                                            Container(height: 10, color: e.getColor),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                // direction: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: BasicClass.systemSetting.exceptionStatusList
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Indicator(color: e.getColor, text: e.title, isSquare: false, size: 12, fontSize: 13),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> showingBarSections(FlightDetails details, List<Position> posList) {
    return posList.map((e) {
      final isTouched = posList.indexOf(e) == touchedIndex;
      double value = 100 * details.tagList.where((element) => element.currentPosition == e.id).length / details.tagList.length;
      final radius = isTouched ? 20.0 : 10.0;
      final fontSize = isTouched ? 25.0 : 14.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 0)];
      return BarChartGroupData(x: value.floor());
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.fontSize = 14,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final double fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

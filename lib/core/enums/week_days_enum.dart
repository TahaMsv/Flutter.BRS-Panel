import 'package:get/utils.dart';

enum WeekDays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

extension WeekDaysDetails on WeekDays {
  String get label => name.capitalizeFirst!;
  String get labelMini {
    switch (this){
      case WeekDays.monday:
        return 'Mon';
      case WeekDays.tuesday:
        return 'Tue';
      case WeekDays.wednesday:
        return 'Wed';
      case WeekDays.thursday:
        return 'Thu';
      case WeekDays.friday:
        return 'Fri';
      case WeekDays.saturday:
        return 'Sat';
      case WeekDays.sunday:
        return 'Sun';
    }
  }
}
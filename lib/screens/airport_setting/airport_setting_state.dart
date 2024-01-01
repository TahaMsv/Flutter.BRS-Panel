import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_setting_class.dart';

final airportSettingProvider = ChangeNotifierProvider<AirportSettingState>((_) => AirportSettingState());

class AirportSettingState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool areSettingUpdated = true;
}

// final selectedAirportProvider = StateProvider<Airport?>((ref) => null);
final settingProvider = StateProvider<AirportSetting?>((ref) => null);

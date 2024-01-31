enum FlightTypeFilter { departure, arrival }

enum FlightTestTypeFilter { test, actual, all }

extension Str on FlightTypeFilter {
  String get toStr {
    switch (this) {
      case FlightTypeFilter.departure:
        return "Departure";
      case FlightTypeFilter.arrival:
        return "Arrival";
    }
  }
}

FlightTypeFilter getFlightTypeFilterFromString(String value) {
  switch (value.toLowerCase()) {
    case 'departure':
      return FlightTypeFilter.departure;
    case 'arrival':
      return FlightTypeFilter.arrival;
    default:
      throw ArgumentError('Invalid value: $value');
  }
}

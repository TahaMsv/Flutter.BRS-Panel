enum FlightTypeFilter {
  departure,
  arrival,
}

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

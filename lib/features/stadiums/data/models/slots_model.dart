class TimeSlot {
  final String start;
  final String end;
  final bool available;

  TimeSlot({
    required this.start,
    required this.end,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      available: json['available'] ?? false,
    );
  }
}

class SlotsResponse {
  final int field;
  final String date;
  final List<TimeSlot> slots;

  SlotsResponse({
    required this.field,
    required this.date,
    required this.slots,
  });

  factory SlotsResponse.fromJson(Map<String, dynamic> json) {
    final rawSlots = json['slots'] as List<dynamic>? ?? [];
    return SlotsResponse(
      field: json['field'] ?? 0,
      date: json['date'] ?? '',
      slots: rawSlots
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

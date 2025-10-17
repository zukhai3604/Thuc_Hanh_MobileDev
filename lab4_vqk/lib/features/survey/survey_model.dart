import 'dart:convert';

class SurveyRecord {
  final double latitude;
  final double longitude;
  final double lightLux;   // -1 nếu không có
  final double accelMag;   // |a|
  final double magField;   // |B|
  final DateTime timestamp;

  SurveyRecord({
    required this.latitude,
    required this.longitude,
    required this.lightLux,
    required this.accelMag,
    required this.magField,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'lat': latitude,
    'lng': longitude,
    'light_lux': lightLux,
    'accel_mag': accelMag,
    'mag_field': magField,
    'timestamp': timestamp.toIso8601String(),
  };

  static SurveyRecord fromJson(Map<String, dynamic> j) => SurveyRecord(
    latitude: (j['lat'] as num).toDouble(),
    longitude: (j['lng'] as num).toDouble(),
    lightLux: (j['light_lux'] as num).toDouble(),
    accelMag: (j['accel_mag'] as num).toDouble(),
    magField: (j['mag_field'] as num).toDouble(),
    timestamp: DateTime.parse(j['timestamp'] as String),
  );
}

class SurveyFile {
  static const fileName = 'schoolyard_map_data.json';

  static String encodeList(List<SurveyRecord> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<SurveyRecord> decodeList(String raw) {
    if (raw.trim().isEmpty) return [];
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => SurveyRecord.fromJson(e as Map<String, dynamic>)).toList();
  }
}

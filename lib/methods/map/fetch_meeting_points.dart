import 'dart:convert';

import 'package:app_test/config.dart';
import 'package:app_test/models/map/meeting_point.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = '${AppConfig.apiUrl}/api/map/meeting-points';

Future<List<MeetingPoint>> fetchMeetingPoints(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseMeetingPoints, response.body);
    } else {
      throw Exception('Failed to load meeting points:c');
    }
  } catch (e) {
    throw Exception('Failed to load meeting points: $e');
  }
}

List<MeetingPoint> parseMeetingPoints(String responseBody) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  final List<dynamic> data = decoded['data'];
  return data.map<MeetingPoint>((json) => MeetingPoint.fromJson(json)).toList();
}

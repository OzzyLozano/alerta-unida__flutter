import 'dart:convert';

import 'package:app_test/components/alert.dart';
import 'package:app_test/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = '${AppConfig.apiUrl}/api/alerts/active';

Future<List<Alert>> fetchReports(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseAlerts, response.body);
    } else {
      throw Exception('Failed to load alerts');
    }
  } catch (e) {
    throw Exception('Failed to load alerts: $e');
  }
}

List<Alert> parseAlerts(String responseBody) {
  final decoded = jsonDecode(responseBody) as List<dynamic>;
  return decoded.map<Alert>((json) => Alert.fromJson(json)).toList();
}

import 'dart:convert';

import 'package:app_test/config.dart';
import 'package:app_test/models/map/gate.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = '${AppConfig.apiUrl}/api/map/gates';

Future<List<Gate>> fetchGates(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseGates, response.body);
    } else {
      throw Exception('Failed to load gates:c');
    }
  } catch (e) {
    throw Exception('Failed to load gates: $e');
  }
}

List<Gate> parseGates(String responseBody) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  final List<dynamic> data = decoded['data'];
  return data.map<Gate>((json) => Gate.fromJson(json)).toList();
}

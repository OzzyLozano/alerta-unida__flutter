import 'dart:convert';

import 'package:app_test/config.dart';
import 'package:app_test/models/map/building.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = '${AppConfig.apiUrl}/api/map/buildings';

Future<List<Building>> fetchBuildings(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseBuildings, response.body);
    } else {
      throw Exception('Failed to load buildings:c');
    }
  } catch (e) {
    throw Exception('Failed to load buildings: $e');
  }
}

List<Building> parseBuildings(String responseBody) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  final List<dynamic> data = decoded['data'];
  return data.map<Building>((json) => Building.fromJson(json)).toList();
}

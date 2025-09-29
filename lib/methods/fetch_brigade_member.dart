import 'dart:convert';

import 'package:app_test/config.dart';
import 'package:app_test/models/brigade_member.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<BrigadeMember> fetchBrigadeMember(http.Client client) async {
  final preferences = await SharedPreferences.getInstance();
  final userId = preferences.getInt("userId");
  final String url = '${AppConfig.apiUrl}/api/brigades/get-data/$userId';
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseUser, response.body);
    } else {
      throw Exception('Failed to load brigade member');
    }
  } catch (e) {
    throw Exception('Failed to find brigade member: $e');
  }
}

BrigadeMember parseUser(String responseBody) {
  final Map<String, dynamic> decoded = jsonDecode(responseBody);
  final data = decoded['data'] ?? decoded;
  return BrigadeMember.fromJson(data);
}

import 'dart:convert';

import 'package:app_test/config.dart';
import 'package:app_test/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<User> fetchUser(http.Client client) async {
  final preferences = await SharedPreferences.getInstance();
  final userId = preferences.getInt("userId");
  final String url = '${AppConfig.apiUrl}/api/users/get-data/$userId';
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseUser, response.body);
    } else {
      throw Exception('Failed to load user');
    }
  } catch (e) {
    throw Exception('Failed to find user: $e');
  }
}

User parseUser(String responseBody) {
  final Map<String, dynamic> decoded = jsonDecode(responseBody);
  final data = decoded['data'] ?? decoded;
  return User.fromJson(data);
}

import 'dart:convert';

import 'package:app_test/components/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = 'http://localhost:5000/getUsers';

Future<List<User>> fetchUsers(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseUsers, response.body);
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    throw Exception('Failed to load users: $e');
  }
}

List<User> parseUsers(String responseBody) {
  final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

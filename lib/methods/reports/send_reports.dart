
import 'package:app_test/config.dart';
import 'package:app_test/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendReport(BuildContext context, String imagePath, String title, String description) async {
  try {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt("userId") ?? 0;
    final uri = Uri.parse('${AppConfig.apiUrl}/api/reports/send-report');
    
    var request = http.MultipartRequest('POST', uri);
    
    var file = await http.MultipartFile.fromPath('img', imagePath);
    request.files.add(file);
    
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['user_id'] = userId.toString();

    var response = await request.send();
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado exitosamente!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      print('Respuesta: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

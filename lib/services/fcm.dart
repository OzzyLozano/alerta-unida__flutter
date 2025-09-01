import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_test/config.dart';

class FCM {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios-unknown';
      }
      return 'unknown-device';
    } catch (e) {
      print('Error getting device ID: $e');
      return 'error-device';
    }
  }

  static Future<void> sendTokenToServer(String token) async {
    try {
      final deviceId = await getDeviceId();
      final preferences = await SharedPreferences.getInstance();
      
      final userId = preferences.getInt('userId');
      final isBrigadeMember = preferences.getBool('isBrigadeMember') ?? false;
      
      if (userId != null && userId > 0) {
        print('=== ENVIANDO TOKEN FCM ===');
        print('User ID: $userId');
        print('Tipo: ${isBrigadeMember ? 'brigade' : 'user'}');
        print('Device ID: $deviceId');
        
        final response = await http.post(
          Uri.parse('${AppConfig.apiUrl}/api/fcm/token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'token': token,
            'device_id': deviceId,
            'user_type': isBrigadeMember ? 'brigade' : 'user',
            'user_id': userId
          }),
        );

        if (response.statusCode == 200) {
          print('Token FCM actualizado para usuario $userId');
        } else {
          print('Error enviando token: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } else {
        print('User ID no válido: $userId');
      }
    } catch (e) {
      print('Error enviando token al servidor: $e');
    }
  }

  // Obtener y enviar token
  static Future<void> getAndSendToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      
      if (token != null) {
        print('Nuevo token FCM: ${token.substring(0, 20)}...');
        await sendTokenToServer(token);
      } else {
        print('No se pudo obtener el token FCM');
      }
    } catch (e) {
      print('Error obteniendo token FCM: $e');
    }
  }

  static Future<void> refreshTokenRelationship() async {
    try {
      final deviceId = await getDeviceId();
      final preferences = await SharedPreferences.getInstance();
      final userId = preferences.getInt('userId');
      final isBrigadeMember = preferences.getBool('isBrigadeMember') ?? false;
      
      if (userId != null && userId > 0) {
        print('=== ACTUALIZANDO RELACIÓN TOKEN ===');
        print('Nuevo User ID: $userId');
        print('Nuevo Tipo: ${isBrigadeMember ? 'brigade' : 'user'}');
        
        final response = await http.post(
          Uri.parse('${AppConfig.apiUrl}/api/fcm/refresh-token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'device_id': deviceId,
            'user_type': isBrigadeMember ? 'brigade' : 'user',
            'user_id': userId
          }),
        );
        
        if (response.statusCode == 200) {
          print('Relación token-usuario actualizada');
        } else {
          print('Error actualizando relación: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error actualizando relación token: $e');
    }
  }

  static Future<void> removeToken() async {
    try {
      final deviceId = await getDeviceId();
      
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/api/fcm/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'device_id': deviceId}),
      );
      
      if (response.statusCode == 200) {
        print('Token FCM eliminado del servidor');
      } else {
        print('Error eliminando token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error eliminando token: $e');
    }
  }
}

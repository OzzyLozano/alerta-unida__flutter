import 'package:app_test/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:app_test/services/notifications_service.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return host == '40.233.17.187';
      };
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  await _setupPushNotifications();

  runApp(const MainApp());
}

const appTitle = 'Alerta Unida';
const TextStyle styleOptions = TextStyle(fontSize: 24,);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splashscreen(),
    );
  }
}

Future<void> _setupPushNotifications() async {
  try {
    // Solicitar permisos para notificaciones
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(
      alert: true,        // Mostrar alertas
      badge: true,        // Mostrar badge en el icono
      sound: true,        // Reproducir sonido
      provisional: false, // Pedir permiso completo al usuario
    );
    
    // Verificar el estado de los permisos
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Usuario concedió permiso para notificaciones');
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Usuario concedió permiso provisional');
    } else {
      print('Usuario denegó o no ha aceptado los permisos');
    }

    // Configurar manejadores para notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Mensaje recibido en primer plano!');
      print('Message data: ${message.data}');
      
      await NotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: message.notification?.title ?? 'Nueva alerta',
        body: message.notification?.body ?? 'Tienes un nuevo mensaje',
        payload: message.data.toString(),
      );
      
      if (message.notification != null) {
        print('Message Notification Title: ${message.notification?.title}');
        print('Message Notification Body: ${message.notification?.body}');
      }
    });

    // Manejar cuando la app está en segundo plano pero abierta
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App abierta desde notificación en segundo plano');
      print('Message data: ${message.data}');
    });

  } catch (e) {
    print('Error configuring push notifications: $e');
  }
}

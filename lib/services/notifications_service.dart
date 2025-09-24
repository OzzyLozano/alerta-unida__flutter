import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Inicializa las notificaciones locales y crea el canal de emergencia
  static Future<void> initialize() async {
    // Configuración para Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Icono de la app

    // Configuración para iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(settings);

    // ✅ Crear canal de emergencia explícitamente para FullScreenIntent
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'alert_channel', // Debe coincidir con el usado en showNotification
      'Alertas importantes',
      description: 'Canal para alertas de emergencia',
      importance: Importance.max, // 🔴 Importante para heads-up/fullscreen
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'), // mp3 en res/raw/
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Mostrar una notificación de alerta **con pop-up (fullscreen)**
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alert_channel', // ID del canal
      'Alertas importantes',
      channelDescription: 'Canal para alertas de emergencia',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
      fullScreenIntent: true, // ⚡ Permite que la notificación abra pantalla completa
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

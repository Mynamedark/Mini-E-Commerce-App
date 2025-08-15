import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initialize({Future<void> Function(RemoteMessage)? backgroundHandler}) async {
    await _messaging.requestPermission();
    if (backgroundHandler != null) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages (add flutter_local_notifications if desired).
    });
  }

  static Future<String?> getToken() => _messaging.getToken();
}

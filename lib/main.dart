import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:preet/providers/auth_provider.dart';
import 'package:preet/providers/cart_provider.dart';
import 'package:preet/providers/locale_provider.dart';
import 'package:preet/providers/product_provider.dart';
import 'package:preet/routes.dart';
import 'package:preet/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

/// Background handler for Firebase Messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message here
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Notifications
  NotificationService.initialize(backgroundHandler: _firebaseMessagingBackgroundHandler);
  Stripe.publishableKey = 'pk_test_51RwKvBKHWml9WIfTaNr9EioNZdqg7Jdq6KmyryREgBIzFe0cqizA9XPJIXsu1WvJU8yENlG7zzFLxaZ9g89bZyKn00A5oBtv9p';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // AuthProvider with init to listen auth state changes
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        // ProductProvider with real-time product listener
        ChangeNotifierProvider(create: (_) => ProductProvider()..listenProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini E-Commerce',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
        initialRoute: Routes.splash,
        routes: Routes.map,
        supportedLocales: const [
          Locale('en'),
          Locale('hi'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

      )

    );
  }
}

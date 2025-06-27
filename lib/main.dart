import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/help_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/change_screen.dart';
import 'screens/delete_account_screen.dart';
import 'screens/notification_screen.dart';
import 'services/fcm_service.dart';
import 'core/config.dart';
import 'dart:async';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

// No se puede hacer servir en web await dotenv.load(fileName: ".env");
// await dotenv.load(fileName: kIsWeb ? "assets/.env" : ".env");
/* dotenv.testLoad(
        fileInput: '''
        API_BASE_URL=https://dev.artacho.org/api
      ''',
      ); */
void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: "assets/.env");
      print("🌍 API_BASE_URL cargada: ${dotenv.env['API_BASE_URL']}");
      print("🌍 API_BASE_URL_WEB cargada: ${dotenv.env['API_BASE_URL_WEB']}");
      // comentar para disposivo fisico
      if (kIsWeb) {
        if (AppConfig.enableFirebase) {
          await Firebase.initializeApp(
            options: FirebaseOptions(
              apiKey: dotenv.env['FIREBASE_API_KEY']!,
              authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
              projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
              storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
              messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
              appId: dotenv.env['FIREBASE_APP_ID']!,
            ),
          );
        }
      } else {
        await Firebase.initializeApp();
      }
      // Para dispositivo fisico
      /*await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY']!,
          authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
          projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
          storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
          messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
          appId: dotenv.env['FIREBASE_APP_ID']!,
        ),
      );*/
      await requestNotificationPermissions();
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      await FCMService.initializeAndSaveToken();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

      runApp(const MyApp());
    },
    (error, stackTrace) {
      print('Uncaught error: $error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artacho App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/help': (context) => const HelpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}

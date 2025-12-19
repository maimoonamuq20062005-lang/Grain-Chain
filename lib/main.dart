import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user_management/login.dart';
import 'user_management/signup.dart';
import 'home/home.dart';
import 'package:provider/provider.dart';
import 'notifications/notification_service.dart';
import 'user_management/splashscreen.dart';
import 'services/data_service.dart';
import 'services/user_session_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize services for data persistence
  await DataService().init();
  await UserSessionService().init();

  // Initialize NotificationService and load saved notifications
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize Google Mobile Ads SDK (AdMob)
  await MobileAds.instance.initialize();

  runApp(
    ChangeNotifierProvider<NotificationService>(
      create: (_) => notificationService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grain Chain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

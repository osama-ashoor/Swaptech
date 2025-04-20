import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaptech2/auth/wrapper.dart';
import 'package:swaptech2/database/database.dart';
import 'package:swaptech2/handling%20notifications/notification.dart';
import 'package:swaptech2/onboarding_screen/onboard.dart';

bool showOnboard = false;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  showOnboard = prefs.getBool('showOnboard') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (context) => Database(),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          '/Wrapper': (context) => const Wrapper(),
        },
        home: const MyApp(),
      ),
    ),
  );
  HandlingNotification().createAndSetupChannel();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showOnboard ? const Wrapper() : const Onboard(),
    );
  }
}

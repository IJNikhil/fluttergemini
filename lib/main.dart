import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttergemini/firebase_options.dart';
import 'package:fluttergemini/pages/home_page.dart';
import 'package:fluttergemini/pages/login.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}



class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.grey.shade900,
    );
  }
}

// constants.dart
class Routes {
  static const String home = "/home";
  static const String login = "/";
}


void main() async {
  await FirebaseInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      routes: {
        Routes.login: (context) => LoginApp(),
        Routes.home: (context) => HomePage(),
      },
    );
  }
}

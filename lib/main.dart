import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrition_app/component/navigation_router.dart';
import 'package:nutrition_app/ui/home.dart';
import 'package:nutrition_app/ui/login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Login(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const Login());
          case '/home':
            return MaterialPageRoute(builder: (context) => const Home());
        // Add other routes as needed
          default:
            return null; // Handle unknown routes gracefully
        }
      },
    );
  }
}

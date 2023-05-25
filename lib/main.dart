import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_app/core/user_event.dart';
import 'package:provider/provider.dart';
import 'ui/component/navigation_router.dart';
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
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // return MultiProvider(
    //   providers: [],
    //   child:
    // );
    return MaterialApp(
      title: "FoodSense",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[900],
      ),
      // home: SafeArea(child: NavRouter(initialRoute: isLoggedIn ? "/home/${UserEvent.defaultEvent.name}" : "/login"))
      home: SafeArea(child: NavRouter(initialRoute: isLoggedIn ? "/home" : "/login"))
    );
  }
}





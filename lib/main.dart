import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrition_app/component/navigation_router.dart';
import 'package:provider/provider.dart';
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
    //   child: NavRouter(
    //     initialRoute: isLoggedIn ? "/home" : "/login",
    //   ),
    // );
    return MaterialApp(
      title: "FoodSense",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green,
      ),
      home: NavRouter(initialRoute: isLoggedIn ? "/home" : "/login")
    );
  }
}





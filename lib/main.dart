import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrition_app/component/navigation_router.dart';
import 'package:nutrition_app/ui/home.dart';
import 'package:nutrition_app/ui/login.dart';
import 'package:nutrition_app/ui/register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if a user is already logged in
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

  runApp(
    NavRouter(
      initialRoute: isLoggedIn ? "/home" : "/login",
    ),
  );
}







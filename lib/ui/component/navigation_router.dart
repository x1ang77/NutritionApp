import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/ui/auth/forgot_password_page.dart';
import 'package:nutrition_app/ui/auth/image_page.dart';
import 'package:nutrition_app/ui/details.dart';
import 'package:nutrition_app/ui/favourite.dart';

import '../auth/onboarding.dart';
import '../diary_page.dart';
import '../home.dart';
import '../logbook.dart';
import '../auth/login.dart';
import '../recipe_page.dart';
import '../auth/register.dart';

class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/diary", builder: (context, state) => const DiaryPage()),
    GoRoute(path: "/logbook", builder: (context, state) => const Logbook()),
    GoRoute(path: "/recipe", builder: (context, state) => const RecipePage()),
    GoRoute(path: "/favorite", builder: (context, state) => const Favourite()),
    GoRoute(path: "/image", builder: (context, state) => const ImagePage()),
    GoRoute(path: "/forgot", builder: (context, state) => const ForgotPasswordPage()),
    // GoRoute(path: "/onboarding", builder: (context, state) => const Onboarding()),
    // GoRoute(path: "/onboarding", name: "image", builder: (context, state) {
    //   Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
    //   return Onboarding(object: extras,);
    // }),
    GoRoute(path: "/details/:id", name:"id", builder: (context, state) =>
        Details(id: state.pathParameters["id"] ?? "",)
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "FoodSense",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      routerConfig: GoRouter(initialLocation: initialRoute, routes: _routes),
    );
  }
}

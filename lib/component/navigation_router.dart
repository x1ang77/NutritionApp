import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/ui/details.dart';
import 'package:nutrition_app/ui/profile.dart';
import 'package:nutrition_app/ui/recipe.dart';
import 'package:path/path.dart';

import '../ui/diary.dart';
import '../ui/home.dart';
import '../ui/login.dart';
import '../ui/register.dart';

class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/diary", builder: (context, state) => const Diary()),
    GoRoute(path: "/profile", builder: (context, state) => const Profile()),
    GoRoute(path:"/recipe", builder: (context, state) => const RecipePage()),
    GoRoute(path: "/details/:id",name:"id", builder: (context, state) => Details(
      id: state.pathParameters["id"] ?? "",

    ))
    // GoRoute(path: "/details", builder:(context, state) => const Details()),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/ui/details.dart';
import 'package:nutrition_app/ui/favourite.dart';
import 'package:nutrition_app/ui/logbook.dart';
import 'package:nutrition_app/ui/recipe_page.dart';

import '../../core/user_event.dart';
import '../diary_page.dart';
import '../home.dart';
import '../login.dart';
import '../register.dart';

class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    // GoRoute(path: "/home/:userEvent", builder: (context, state) => Home(userEvent: state.pathParameters["userEvent"].toString())),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/diary", builder: (context, state) => const DiaryPage()),
    GoRoute(path: "/favorite", builder: (context, state) => const Favourite()),
    GoRoute(path: "/recipe", builder: (context, state) => const RecipePage()),
    GoRoute(path: "/details/:id",name:"id", builder: (context, state) => Details(
      id: state.pathParameters["id"] ?? "",
    )),
    GoRoute(path: "/logbook", builder: (context, state) => const Logbook())
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

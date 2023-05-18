import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home.dart';
import 'login.dart';


class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: MaterialApp.router(
          routerConfig:
          GoRouter(initialLocation: initialRoute, routes: _routes)),
    );
  }
}

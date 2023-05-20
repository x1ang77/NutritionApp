import 'package:flutter/material.dart';
import 'package:nutrition_app/component/bottom_nav_bar.dart';
import 'package:nutrition_app/component/drawer.dart';
import 'package:nutrition_app/ui/dashboard.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: MyDrawer(),
      body: Dashboard(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

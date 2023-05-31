import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Expanded(
          //     child: PageView.builder(
          //       scrollDirection: Axis.horizontal,
          //       onPageChanged: (value) {
          //         _selectedIndex = value;
          //       },
          //       itemBuilder: itemBuilder,
          //       itemCount: slides.length,
          //     )
          // )
        ],
      ),
    );
  }
}

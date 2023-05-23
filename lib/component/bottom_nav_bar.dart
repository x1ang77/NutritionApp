import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nutrition_app/ui/diary.dart';

import '../ui/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Diary(),
    Text(
      'Recipes',
      style: optionStyle,
    ),
    // Text(
    //   'Add food to diary',
    //   style: optionStyle,
    // ),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
          gap: 20,
          tabs: [
            GButton(
                icon: FontAwesomeIcons.book,
                text: "Diary",
            ),
            GButton(
              icon: Icons.restaurant_menu,
              text: "Recipes",
            ),
            GButton(
              icon: FontAwesomeIcons.person,
              text: "Me",
            ),
          ]
      ),


      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: FaIcon(FontAwesomeIcons.book),
      //       label: 'Diary',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Recipes',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: SizedBox.shrink(
      //     //     child: Icon(Icons.add),
      //     //   ),
      //     //   label: ""
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Me',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.green[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}

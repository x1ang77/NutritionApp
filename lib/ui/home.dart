import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrition_app/core/user_event.dart';
import 'package:nutrition_app/ui/component/drawer.dart';
import 'package:nutrition_app/ui/component/snackbar.dart';
import 'package:nutrition_app/ui/diary.dart';
import 'package:nutrition_app/ui/profile.dart';
import 'package:nutrition_app/ui/recipe.dart';

import '../core/service/shared_preference.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  // const Home({Key? key, required this.userEvent}) : super(key: key);
  // final String userEvent;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Diary(),
    RecipePage(),
    Profile()
  ];

  // @override
  // didChangeDependencies() {
  //   super.didChangeDependencies();
  //   showSnack();
  // }

  // Future<void> showSnack() async {
  //   if (widget.userEvent == UserEvent.login.name) {
  //     showSnackbar2(context, "Successfully logged in", Colors.green);
  //   } else if (widget.userEvent == UserEvent.register.name) {
  //     showSnackbar2(context, "Successfully registered", Colors.green);
  //   }
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),

      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      // bottomNavigationBar: GNav(
      //     gap: 20,
      //     tabs: [
      //       GButton(
      //           icon: FontAwesomeIcons.book,
      //           text: "Diary",
      //       ),
      //       GButton(
      //         icon: Icons.restaurant_menu,
      //         text: "Recipes",
      //       ),
      //       GButton(
      //         icon: FontAwesomeIcons.person,
      //         text: "Me",
      //       ),
      //     ]
      // ),
    );
  }
}

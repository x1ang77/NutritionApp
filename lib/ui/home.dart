import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nutrition_app/ui/diary_page.dart';
import 'package:nutrition_app/ui/favourite.dart';
import 'package:nutrition_app/ui/profile.dart';
import 'package:nutrition_app/ui/recipe_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DiaryPage(),
    RecipePage(),
    Favourite(),
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
      backgroundColor: Colors.grey.shade300,
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GNav(
              color: Colors.grey.shade400,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.green,
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tabs: const [
                GButton(
                  icon: CupertinoIcons.book_solid,
                  text: 'Diary',
                ),
                GButton(
                  icon: Icons.restaurant_menu,
                  text: 'Recipes',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favorites',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Me',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                _onItemTapped(index);
              },
          ),
        ),
      ),
    );
  }
}

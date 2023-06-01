import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nutrition_app/data/model/user.dart';
import 'package:nutrition_app/ui/diary_page.dart';
import 'package:nutrition_app/ui/favourite.dart';
import 'package:nutrition_app/ui/profile.dart';
import 'package:nutrition_app/ui/recipe_page.dart';

import '../core/custom_exception.dart';
import '../data/repository/user/user_repository_impl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserRepoImpl userRepo = UserRepoImpl();
  User? user;

  int _selectedIndex = 0;
  // static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DiaryPage(),
    RecipePage(),
    Favourite(),
    Profile()
  ];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    try {
      var _firebaseUser = userRepo.getCurrentUser();
      if (_firebaseUser != null) {
        var _user = await userRepo.getUserById(_firebaseUser.uid);
        setState(() {
          user = _user;
          if(user != null && user?.completedOnboarding == false) {
            context.go("/onboarding");
          }
        });
      } else {
        throw CustomException("Can't fetch user data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          ),
          boxShadow: [BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // Shadow position
          )]
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

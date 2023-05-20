import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    navigateToLogin() {
      context.pop;
      context.go("/login");
    }

    logout() async {
      try {
        await FirebaseAuth.instance.signOut();
        navigateToLogin();
      } catch (e) {
        // An error occurred while signing out
        debugPrint('Error signing out: $e');
        // Show an error message or handle the error accordingly
      }
    }

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}

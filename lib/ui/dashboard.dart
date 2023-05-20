import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // _signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     // Navigate to login screen or any other screen
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       '/login',
  //           (route) => false,
  //     );
  //   } catch (e) {
  //     // Handle logout error
  //     print('Logout Error: $e');
  //   }
  // }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _navigateToLogin();
    } catch (e) {
      // An error occurred while signing out
      debugPrint('Error signing out: $e');
      // Show an error message or handle the error accordingly
    }
  }

  _navigateToLogin() {
    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                'Dashboard',
                style: optionStyle,
              ),
              ElevatedButton(onPressed: () => _logout(), child: const Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}

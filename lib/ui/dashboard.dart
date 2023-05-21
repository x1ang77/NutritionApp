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

  final int consumedCalories = 2000;
  final int recommendedCalories = 2500;

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    double progress = consumedCalories / recommendedCalories;
    int remainingCalories = recommendedCalories - consumedCalories;

    return Scaffold(
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
            Text("Today"),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      children: [
                        Text(
                            "$consumedCalories",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        const Text(
                            'Consumed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                            )
                        )
                      ]
                  ),

                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.green[100],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$remainingCalories",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const Text(
                              'Remaining',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                              )
                          )
                        ]
                      ),
                    ]
                  ),

                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        const Text(
                            'Burned',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                            )
                        )
                      ]
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

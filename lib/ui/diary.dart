import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  DateTime selectedDate = DateTime.now();
  String _formatDate(DateTime date) {
    DateTime currentDate = DateTime.now();

    if (date.year == currentDate.year &&
        date.month == currentDate.month &&
        date.day == currentDate.day) {
      return 'Today';
    } else if(date.day == currentDate.day - 1) {
      return 'Yesterday';
    } else {
      // return '${date.day}/${date.month}/${date.year}';
      return '${DateFormat("dd/MM/yyyy").format(date)}';
    }
  }

  final List<String> breakfastItems = ['Eggs', 'Toast', 'Cereal'];
  final List<String> lunchItems = ['Salad', 'Sandwich', 'Soup'];
  final List<String> dinnerItems = ['Steak', 'Pasta', 'Chicken'];
  final List<String> snackItems = ['Fruit', 'Yogurt', 'Nuts'];
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

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

  final double recommendedCalories = 2500; // kJ / kcal
  final double consumedCalories = 2000;
  final double burnedCalories = 200;

  final double carbohydrateGoal = 600; // g
  final double proteinGoal = 100;
  final double fatGoal = 40;

  final double carbohydrate = 409.1;
  final double protein = 28.3;
  final double fat = 25.6;

  Widget buildListSection(String title, List<String> items) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = consumedCalories / recommendedCalories;
    int remainingCalories = (recommendedCalories - consumedCalories).round();

    double carboProgress = carbohydrate / carbohydrateGoal;
    double proteinProgress = protein / proteinGoal;
    double fatProgress = fat / fatGoal;
    int remainingCarbo = (carbohydrateGoal - carbohydrate).round();
    int remainingProtein = (proteinGoal - protein).round();
    int remainingFat = (fatGoal - fat).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        size: 32,
                        Icons.chevron_left,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.subtract(Duration(days: 1));
                        });
                      },
                    ),
                    Text(
                      _formatDate(selectedDate),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        size: 32,
                        Icons.chevron_right
                    ),
                      onPressed: () {
                        DateTime displayDate = selectedDate.add(Duration(days: 1));
                        DateTime currentDate = DateTime.now();

                        if (displayDate.isBefore(currentDate) || DateTime(displayDate.year, displayDate.month, displayDate.day) == DateTime(currentDate.year, currentDate.month, currentDate.day)) {
                          setState(() {
                            selectedDate = displayDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              Text(
                                  'Remaining',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green[400]
                                  )
                              )
                            ]
                        ),
                      ]
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "$consumedCalories",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(
                          'Consumed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange[500]
                          )
                      )
                    ]
                ),

                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "$burnedCalories",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                          'Burned',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple[300]
                          )
                      )
                    ]
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: carboProgress,
                            strokeWidth: 10,
                            backgroundColor: Colors.brown[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "$remainingCarbo",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.brown,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Text(
                                    'Carbohydrate',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.brown[400]
                                    )
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: proteinProgress,
                            strokeWidth: 10,
                            backgroundColor: Colors.pink[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "$remainingProtein",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.pink,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Text(
                                    'Protein',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.pink[400]
                                    )
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: fatProgress,
                            strokeWidth: 10,
                            backgroundColor: Colors.blue[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "$remainingFat",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Text(
                                    'Fat',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue[400]
                                    )
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   prototypeItem: buildListSection('Breakfast', breakfastItems),
                  //   padding: const EdgeInsets.all(8.0),
                  //   itemCount: 4, // Number of sections (breakfast, lunch, dinner, snack)
                  //   itemBuilder: (BuildContext context, int index) {
                  //     if (index == 0) {
                  //       return buildListSection('Breakfast', breakfastItems);
                  //     } else if (index == 1) {
                  //       return buildListSection('Lunch', lunchItems);
                  //     } else if (index == 2) {
                  //       return buildListSection('Dinner', dinnerItems);
                  //     } else if (index == 3) {
                  //       return buildListSection('Snack', snackItems);
                  //     }
                  //     // return Container();
                  //   },
                  // ),

                  // Expanded(
                  //     child: ListView.builder(
                  //       // scrollDirection: Axis.horizontal,
                  //       itemCount: 4,
                  //       itemBuilder: (context, index) {
                  //         switch (index) {
                  //           case 0:
                  //             return buildListSection('Breakfast', breakfastItems);
                  //           case 1:
                  //             return buildListSection('Lunch', lunchItems);
                  //           case 2:
                  //             return buildListSection('Dinner', dinnerItems);
                  //           case 3:
                  //             return buildListSection('Snack', snackItems);
                  //           default:
                  //             return Container();
                  //         }
                  //       },
                  //     ),
                  // )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}

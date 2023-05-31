import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/diary.dart';
import 'package:nutrition_app/data/repository/diary/diary_repository_impl.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../core/custom_exception.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  UserRepoImpl userRepo = UserRepoImpl();
  DiaryRepoImpl diaryRepo = DiaryRepoImpl();

  Diary? todayDiary;
  DateTime selectedDate = DateTime.now();

  var userId = "";
  final List<String> breakfastItems = ['Eggs', 'Toast', 'Cereal'];
  final List<String> lunchItems = ['Salad', 'Sandwich', 'Soup'];
  final List<String> dinnerItems = ['Steak', 'Pasta', 'Chicken'];
  final List<String> snackItems = ['Fruit', 'Yogurt', 'Nuts'];
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  double recommendedCalories = 0; // kJ / kcal
  double consumedCalories = 0;
  final double burnedCalories = 200;

  final double carbohydrateGoal = 600; // g
  final double proteinGoal = 100;
  final double fatGoal = 40;

  final double carbohydrate = 409.1;
  final double protein = 28.3;
  final double fat = 25.6;

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
      return '${DateFormat("yMd").format(date)}';
    }
  }

  double calculateProgress(double value, double maxValue) {
    if (maxValue == 0) {
      return 0.0; // Avoid division by zero
    }
    return value / maxValue;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    try {
      var user = userRepo.getCurrentUser();
      if (user != null) {
        userId = user.uid;
        var formattedDate = DateFormat("yMd").format(selectedDate);
        _getDiary(userId, formattedDate);
      } else {
        throw CustomException("Can't fetch user data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future _getDiary(String userId, String date) async {
    try {
      var diary = await diaryRepo.getDiary(userId, date);
      setState(() {
        todayDiary = diary;
        recommendedCalories = todayDiary?.caloriesGoals ?? 0;
        consumedCalories = todayDiary?.caloriesConsumed ?? 0;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final String breakfast = todayDiary?.breakfast ?? "";
    final String lunch = todayDiary?.lunch ?? "";
    final String dinner = todayDiary?.dinner ?? "";

    double progress = calculateProgress(consumedCalories, recommendedCalories);
    int remainingCalories = (recommendedCalories - consumedCalories).round();

    double carboProgress = carbohydrate / carbohydrateGoal;
    double proteinProgress = protein / proteinGoal;
    double fatProgress = fat / fatGoal;
    int remainingCarbo = (carbohydrateGoal - carbohydrate).round();
    int remainingProtein = (proteinGoal - protein).round();
    int remainingFat = (fatGoal - fat).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          size: 32,
                          Icons.chevron_left,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedDate = selectedDate.subtract(const Duration(days: 1));
                            todayDiary = null;
                            recommendedCalories = 0;
                            consumedCalories = 0;
                            _getDiary(userId, DateFormat("yMd").format(selectedDate));
                          });
                        },
                      ),

                      Text(
                        _formatDate(selectedDate),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          size: 32,
                          Icons.chevron_right
                        ),
                        onPressed: () {
                          DateTime displayDate = selectedDate.add(const Duration(days: 1));
                          DateTime currentDate = DateTime.now();

                          if (displayDate.isBefore(currentDate) ||
                              DateTime(displayDate.year, displayDate.month, displayDate.day) ==
                                  DateTime(currentDate.year, currentDate.month, currentDate.day)) {
                            setState(() {
                              selectedDate = displayDate;
                              todayDiary = null;
                              recommendedCalories = 0;
                              consumedCalories = 0;
                              _getDiary(userId, DateFormat("yMd").format(selectedDate));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.only(top: 8),
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
                    padding: const EdgeInsets.only(bottom: 8),
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
                ],
              ),
            ),

            Container(
              // margin: const EdgeInsets.,
              child: Expanded(
                child: ListView(
                  children: [
                    Text("$breakfast"),
                    Text("$lunch"),
                    Text("$dinner")
                  ],
                ),
              ),
            )

            // Expanded(
            //         child: ListView.builder(
            //           // scrollDirection: Axis.horizontal,
            //           itemCount: 4,
            //           itemBuilder: (context, index) {
            //             switch (index) {
            //               case 0:
            //                 return buildListSection('Breakfast', breakfastItems);
            //               case 1:
            //                 return buildListSection('Lunch', lunchItems);
            //               case 2:
            //                 return buildListSection('Dinner', dinnerItems);
            //               case 3:
            //                 return buildListSection('Snack', snackItems);
            //               default:
            //                 return Container();
            //             }
            //           },
            //         ),
            //     )

            // Column(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: ListView.builder(
            //         itemCount: 4,
            //         itemBuilder: (context, index) {
            //           switch (index) {
            //             case 1:
            //               return buildListSection('Breakfast', breakfastItems);
            //             case 2:
            //               return buildListSection('Lunch', lunchItems);
            //             case 3:
            //               return buildListSection('Dinner', dinnerItems);
            //             case 4:
            //               return buildListSection('Snack', snackItems);
            //             default:
            //               return Container();
            //           }
            //         }
            //       ),
            //     )
            //
            //     // Expanded(
            //     //   flex: 1,
            //     //     child: ListView.builder(
            //     //       // scrollDirection: Axis.horizontal,
            //     //       itemCount: 4,
            //     //       itemBuilder: (context, index) {
            //     //         switch (index) {
            //     //           case 0:
            //     //             return buildListSection('Breakfast', breakfastItems);
            //     //           case 1:
            //     //             return buildListSection('Lunch', lunchItems);
            //     //           case 2:
            //     //             return buildListSection('Dinner', dinnerItems);
            //     //           case 3:
            //     //             return buildListSection('Snack', snackItems);
            //     //           default:
            //     //             return Container();
            //     //         }
            //     //       },
            //     //     ),
            //     // )
            //   ]
            // )
          ],
        ),
      ),
    );
  }

  // Widget buildListSection(String title, List<String> items) {
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         ListTile(
  //           title: Text(
  //             title,
  //             style: const TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         const Divider(),
  //         Expanded(
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: items.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ListTile(
  //                 title: Text(items[index]),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

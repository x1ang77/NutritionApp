import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/diary.dart';
import 'package:nutrition_app/data/repository/diary/diary_repository_impl.dart';
import 'package:nutrition_app/data/repository/recipe/recipe_repository_impl.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../core/custom_exception.dart';
import '../data/model/recipe.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  UserRepoImpl userRepo = UserRepoImpl();
  DiaryRepoImpl diaryRepo = DiaryRepoImpl();
  RecipeRepoImpl recipeRepo = RecipeRepoImpl();

  Diary? todayDiary;
  DateTime selectedDate = DateTime.now();

  var userId = "";
  // final List<String> breakfastMeals = ['Eggs', 'Toast', 'Cereal'];
  // final List<String> lunchMeals = ['Salad', 'Sandwich', 'Soup', "tSFqEBsKuQLymnerRHP6"];
  // final List<String> dinnerMeals = ['Steak', 'Pasta', 'Chicken'];
  final List<String> breakfastItems = ['tSFqEBsKuQLymnerRHP6'];
  final List<String> lunchItems = ["tSFqEBsKuQLymnerRHP6"];
  final List<String> dinnerItems = ["tSFqEBsKuQLymnerRHP6"];

  final List<Recipe> breakfastMeals = [];
  final List<Recipe> lunchMeals = [];
  final List<Recipe> dinnerMeals = [];

  double recommendedCalories = 0.0; // kJ / kcal
  double consumedCalories = 0.0;
  double burnedCalories = 0.0;

  final double carbGoal = 0.0; // g
  final double proteinGoal = 0.0;
  final double fatGoal = 0.0;

  final double carbConsumed = 0.0;
  final double proteinConsumed = 0.0;
  final double fatConsumed = 0.0;

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
      return DateFormat("yMd").format(date);
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
    getAllMeals();
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

  Future getAllMeals() async {
    for (var index in breakfastItems) {
      var meal = await recipeRepo.getRecipe(index);
      setState(() {
        breakfastMeals.add(meal);
      });
    }

    for (var index in lunchItems) {
      var meal = await recipeRepo.getRecipe(index);
      setState(() {
        lunchMeals.add(meal);
      });
    }

    for (var index in dinnerItems) {
      var meal = await recipeRepo.getRecipe(index);
      setState(() {
        dinnerMeals.add(meal);
      });
    }
  }

  void _navigateToLogbook() {
    context.push("/logbook");
  }

  @override
  Widget build(BuildContext context) {
    final String breakfast = todayDiary?.breakfast ?? "";
    final String lunch = todayDiary?.lunch ?? "";
    final String dinner = todayDiary?.dinner ?? "";

    double progress = calculateProgress(consumedCalories, recommendedCalories);
    int remainingCalories = (recommendedCalories - consumedCalories).round();

    double carbProgress = calculateProgress(carbConsumed, carbGoal);
    double remainingCarb = carbGoal - carbConsumed;

    double proteinProgress = calculateProgress(proteinConsumed, proteinGoal);
    double remainingProtein = proteinGoal - proteinConsumed;

    double fatProgress = calculateProgress(fatConsumed, fatGoal);
    double remainingFat = fatGoal - fatConsumed;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.grey.shade300,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
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
                    margin: const EdgeInsets.all(0),
                    // margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      color: Colors.white,
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
                                          value: carbProgress,
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
                                                  "${remainingCarb}g",
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
                                                  "${remainingProtein}g",
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
                                                  "${remainingFat}g",
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
                  ),

                  const SizedBox(height: 20,),

                  Expanded(
                    child: _buildMealSection(
                      "Breakfast",
                      breakfastMeals
                    ),
                  ),

                  const SizedBox(height: 20,),

                  Expanded(
                    child: _buildMealSection(
                      "Lunch",
                      lunchMeals
                    ),
                  ),

                  const SizedBox(height: 20,),

                  Expanded(
                    child: _buildMealSection(
                      "Dinner",
                      dinnerMeals,
                    ),
                  ),

                  const SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _navigateToLogbook(),
        child: const Icon(Icons.add, color: Colors.green,),
      ),
    );
  }

  Widget _buildMealSection(
      String header, List<Recipe> meals
      ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.green,
            child: ListTile(
              title: Text(
                header,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),

          Flexible(
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      title: Text(
                        meal.name ?? "",
                      ),
                      trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.remove, size: 20),
                      ),
                    );},
              ),
            ),
          )
        ],
      ),
    );
  }
}

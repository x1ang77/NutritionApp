import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/diary.dart';
import 'package:nutrition_app/data/model/user.dart' as user_model;
import 'package:nutrition_app/data/repository/diary/diary_repository_impl.dart';
import 'package:nutrition_app/data/repository/recipe/recipe_repository_impl.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../core/custom_exception.dart';
import '../data/model/recipe.dart';
import 'component/snackbar.dart';

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

  user_model.User? user;
  var userId = "";
  List<String> mealItems = [];
  List<Recipe> breakfastMeals = [];
  List<Recipe> lunchMeals = [];
  List<Recipe> dinnerMeals = [];

  double recommendedCalories = 0.0;
  double consumedCalories = 0.0;
  double burnedCalories = 0.0;

  double carbGoal = 0.0; // g
  double proteinGoal = 0.0;
  double fatGoal = 0.0;

  double carbConsumed = 0.0;
  double proteinConsumed = 0.0;
  double fatConsumed = 0.0;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String _formatDate(DateTime date) {
    DateTime currentDate = DateTime.now();

    if (date.year == currentDate.year &&
        date.month == currentDate.month &&
        date.day == currentDate.day) {
      return 'Today';
    } else if(date.day == currentDate.day - 1) {
      return 'Yesterday';
    } else {
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
    _getFirebaseUser();
    _getUser(userId);
    _getDiary(userId, DateFormat("yMd").format(selectedDate));
  }

  void _getFirebaseUser() {
    try {
      var firebaseUser = userRepo.getCurrentUser();
      if (firebaseUser != null) {
        setState(() {
          userId = firebaseUser.uid;
        });
      } else {
        throw CustomException("Can't fetch Firebase user data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getUser(String userId) async {
    try {
      var _user = await userRepo.getUserById(userId);
      setState(() {
        user = _user;
      });
    } catch (e) {
      throw CustomException("Can't fetch user data");
    }
  }

  Future<void> _getDiary(String userId, String date) async {
    try {
      var diary = await diaryRepo.getDiary(userId, date);
      setState(() {
        todayDiary = diary;
        mealItems = todayDiary?.meals ?? [];
        recommendedCalories = todayDiary?.caloriesGoal ?? 0.0;
        carbGoal = todayDiary?.carbGoal ?? 0.0;
        proteinGoal = todayDiary?.proteinGoal ?? 0.0;
        fatGoal = todayDiary?.fatGoal ?? 0.0;
        _getAllMeals();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getAllMeals() async {
    for (var index in mealItems) {
      debugPrint("Inside meals $mealItems");
      var meal = await recipeRepo.getRecipe(index);
      setState(() {
        if (meal.mealTime == "Breakfast") {
          // breakfastMeals.clear();
          breakfastMeals.add(meal);
          debugPrint("how many ${breakfastMeals.length} and inside ${meal.name}");
          consumedCalories += meal.calorie;
          carbConsumed += meal.carb;
          proteinConsumed += meal.protein;
          fatConsumed += meal.fat;
        } else if (meal.mealTime == "Lunch") {
          // lunchMeals.clear();
          lunchMeals.add(meal);
          consumedCalories += meal.calorie;
          carbConsumed += meal.carb;
          proteinConsumed += meal.protein;
          fatConsumed += meal.fat;
        } else {
          // dinnerMeals.clear();
          dinnerMeals.add(meal);
          consumedCalories += meal.calorie;
          carbConsumed += meal.carb;
          proteinConsumed += meal.protein;
          fatConsumed += meal.fat;
        }
      });
    }
  }

  Future<void> _removeMeal(String diaryId, String mealId) async {
    try {
      var meal = await recipeRepo.getRecipe(mealId);
      await diaryRepo.removeMealFromDiary(diaryId, mealId);
      setState(() {
        breakfastMeals.removeWhere((meal) => meal.id == mealId);
        lunchMeals.removeWhere((meal) => meal.id == mealId);
        dinnerMeals.removeWhere((meal) => meal.id == mealId);
        consumedCalories -= meal.calorie;
        carbConsumed -= meal.carb;
        proteinConsumed -= meal.protein;
        fatConsumed -= meal.fat;
        showSnackbar(context, "Removed ${meal.name} from diary", Colors.grey);
      });
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, "Failed to remove meal", Colors.red);
    }
  }

  void _clearData() {
    todayDiary = null;
    breakfastMeals.clear();
    lunchMeals.clear();
    dinnerMeals.clear();
    recommendedCalories = 0;
    consumedCalories = 0;
    carbGoal = 0;
    carbConsumed = 0;
    proteinGoal = 0;
    proteinConsumed = 0;
    fatGoal = 0;
    fatConsumed = 0;
  }

  Future<void> _navigateToLogbook() async {
    final result = await context.push<bool>("/logbook");
    if (result != null && result) {
      _getUser(userId);
    }
    refreshKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress(consumedCalories, recommendedCalories);
    int remainingCalories = (recommendedCalories - consumedCalories).round();
    String formattedCalorie = remainingCalories.toStringAsFixed(1);

    double carbProgress = calculateProgress(carbConsumed, carbGoal);
    double remainingCarb = carbGoal - carbConsumed;
    String formattedCarb = remainingCarb.toStringAsFixed(1);

    double proteinProgress = calculateProgress(proteinConsumed, proteinGoal);
    double remainingProtein = proteinGoal - proteinConsumed;
    String formattedProtein = remainingProtein.toStringAsFixed(1);

    double fatProgress = calculateProgress(fatConsumed, fatGoal);
    double remainingFat = fatGoal - fatConsumed;
    String formattedFat = remainingFat.toStringAsFixed(1);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Diary"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => _navigateToLogbook(),
              icon: const Icon(Icons.add_circle, size: 32,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () =>
              _getDiary(userId, DateFormat("yMd").format(selectedDate)),
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
                                _clearData();
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
                                  _clearData();
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
                                              formattedCalorie,
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
                                                "${formattedCarb}g",
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
                                                "${formattedProtein}g",
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
                                                "${formattedFat}g",
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

                Column(
                  children: [
                    const SizedBox(height: 20,),

                    _buildMealSection(
                        "Breakfast",
                        breakfastMeals
                    ),

                    const SizedBox(height: 20,),

                    _buildMealSection(
                        "Lunch",
                        lunchMeals
                    ),

                    const SizedBox(height: 20,),

                    _buildMealSection(
                      "Dinner",
                      dinnerMeals,
                    ),

                    const SizedBox(height: 20,),
                  ],
                )
              ],
            ),
          ),
        ),
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

          Container(
            color: Colors.white,
            child: meals.isNotEmpty
            ? ListView.builder(
              shrinkWrap: true,
              // separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                debugPrint("What about here $meal");
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    meal.name,
                  ),
                  subtitle: Text(
                    "${meal.calorie}kcal",
                    style: const TextStyle(
                      color: Colors.lightGreen
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _removeMeal(todayDiary?.id ?? "", meal.id);
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.grey.shade400,
                    ),
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
            )
                : const ListTile(
              title: Text(
                "No meals available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}

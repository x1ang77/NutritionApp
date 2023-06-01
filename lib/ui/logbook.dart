import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/user.dart' as user_model;
import 'package:nutrition_app/data/repository/diary/diary_repository_impl.dart';
import 'package:nutrition_app/ui/component/snackbar.dart';
import '../core/custom_exception.dart';
import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class Logbook extends StatefulWidget {
  const Logbook({Key? key}) : super(key: key);

  @override
  State<Logbook> createState() => _LogbookState();
}

class _LogbookState extends State<Logbook> {
  final userRepo = UserRepoImpl();
  final diaryRepo = DiaryRepoImpl();

  var userId = "";
  user_model.User? user;
  List<String> meals = [];
  final List<Recipe> _allRecipes = [];
  final List<Recipe> _breakfastRecipes = [];
  final List<Recipe> _lunchRecipes = [];
  List<Recipe> _dinnerRecipes = [];
  bool _isBreakfastExpanded = false;
  bool _isLunchExpanded = false;
  bool _isDinnerExpanded = false;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
    _getUser(userId);
    getRecipe();
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

  Future _getUser(String userId) async {
    try {
      var _user = await userRepo.getUserById(userId);
      setState(() {
        user = _user;
      });
    } catch (e) {
      throw CustomException("Can't fetch user data");
    }
  }

  Future getRecipe() async {
    var collection = FirebaseFirestore.instance.collection("recipes");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      setState(() {
        if (recipe.mealTime == "Breakfast") {
          _breakfastRecipes.add(recipe);
        }
        if (recipe.mealTime == "Lunch") {
          _lunchRecipes.add(recipe);
        }
        if (recipe.mealTime == "Dinner") {
          _dinnerRecipes.add(recipe);
        }
        _allRecipes.add(recipe);
      });
    }
  }

  Future _addMealToList(String id, Recipe recipe) async {
    try {
      var date = DateFormat.yMd().format(DateTime.now());
      setState(() {
        meals.add(id);
      });
      await diaryRepo.addToDiary(
          userId, date, meals,
          user?.calorieGoal ?? 0.0, user?.carbGoal ?? 0.0,
          user?.proteinGoal ?? 0.0, user?.fatGoal ?? 0.0,
          id
      );
      setState(() {
        showSnackbar(context, "Added meal to diary", Colors.green);
      });
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, "Failed to add meal to diary", Colors.red);
    }
  }

  // _addToDiaries() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser;
  //   var currentUser = await userRepo.getUserById(firebaseUser!.uid);
  //   var timeStamp = DateTime.now();
  //   var date = DateFormat.yMd().format(timeStamp);
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference diaries = firestore.collection("diaries");
  //
  //   // Check if a diary with the same timestamp and userId already exists
  //   var querySnapshot = await diaries
  //       .where('date', isEqualTo: date)
  //       .where('user_id', isEqualTo: currentUser?.id)
  //       .limit(1)
  //       .get();
  //   debugPrint("${querySnapshot.docs}");
  //   if (querySnapshot.docs.isEmpty) {
  //     var id = diaries.doc().id;
  //
  //     var diaryData = Diary(
  //       date: date,
  //       id: id,
  //       userId: currentUser?.id,
  //       // breakfast: _mealsId[0],
  //       // lunch: _mealsId[1],
  //       // dinner: _mealsId[2],
  //       caloriesGoal: currentUser?.calorieGoal,
  //     ).toMap(); // Convert Diary object to Map
  //
  //     diaries.doc(id).set(diaryData);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text("Meals"), centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Welcome to your meals!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "There is a variety to choose from:",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildMealTimeSection(
              "Breakfast",
              _breakfastRecipes,
              _isBreakfastExpanded,
              () {
                setState(() {
                  _isBreakfastExpanded = !_isBreakfastExpanded;
                });
              },
            ),
            _buildMealTimeSection(
              "Lunch",
              _lunchRecipes,
              _isLunchExpanded,
              () {
                setState(() {
                  _isLunchExpanded = !_isLunchExpanded;
                });
              },
            ),
            _buildMealTimeSection(
              "Dinner",
              _dinnerRecipes,
              _isDinnerExpanded,
              () {
                setState(() {
                  _isDinnerExpanded = !_isDinnerExpanded;
                });
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Instructions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "1. Tap on each meal time section to expand and view available recipes.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "2. Tap on the '+' icon next to a recipe to add it to your diaries.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     "*Add only one meal for each time of day.",
            //     style: TextStyle(fontSize: 16, color: Colors.red),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeSection(
      String title, List<Recipe> recipes, bool isExpanded, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.all(0),
          elevation: isExpanded ? 4 : 0,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          child: Container(
            color: Colors.lightGreen,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 30,
              ),
              onTap: onTap,
            ),
          ),
        ),

        if (isExpanded)
          recipes.isNotEmpty
          ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                tileColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                title: Text(
                  recipe.name ?? "",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 250, // Set the desired width
                      child: Text(
                        "${recipe.calorie} kcal | ${recipe.carb} g | ${recipe.protein} g | ${recipe.fat}g",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton.icon(
                  // onPressed: () => _pushToMealsId(recipe.id!),
                  onPressed: () => _addMealToList(recipe.id ?? "", recipe),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              );
            },
          ) : const ListTile(
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            title: Text(
              "No meals available",
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/user.dart' as user_model;
import '../data/model/diary.dart';
import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class Logbook extends StatefulWidget {
  const Logbook({Key? key}) : super(key: key);

  @override
  State<Logbook> createState() => _LogbookState();
}

class _LogbookState extends State<Logbook> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _breakfastRecipes = [];
  List<Recipe> _lunchRecipes = [];
  List<Recipe> _dinnerRecipes = [];
  List<String> _mealsId = [];
  int _arraylength = 0;
  bool _isBreakfastExpanded = false;
  bool _isLunchExpanded = false;
  bool _isDinnerExpanded = false;
  var repo = UserRepoImpl();

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  Future getRecipe() async {
    var collection = FirebaseFirestore.instance.collection("meals");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      // debugPrint("${recipe.image?[0]}");
      setState(() {
        // if (recipe.mealTime == "morning") {
        //   _breakfastRecipes.add(recipe);
        // }
        // if (recipe.mealTime == "afternoon") {
        //   _lunchRecipes.add(recipe);
        // }
        // if (recipe.mealTime == "night") {
        //   _dinnerRecipes.add(recipe);
        // }
        _allRecipes.add(recipe);
      });
    }
  }

  _pushToMealsId(String id) {
    _mealsId.add(id);
    setState(() {
      _arraylength = _mealsId.length;
    });
  }

  _addToDiaries() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    var currentUser = await repo.getUserById(firebaseUser!.uid);
    var timeStamp = DateTime.now();
    var date = DateFormat.yMd().format(timeStamp);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference diaries = firestore.collection("diaries");

    // Check if a diary with the same timestamp and userId already exists
    var querySnapshot = await diaries
        .where('date', isEqualTo: date)
        .where('user_id', isEqualTo: currentUser?.id)
        .limit(1)
        .get();
    debugPrint("${querySnapshot.docs}");
    if (querySnapshot.docs.isEmpty) {
      var id = diaries.doc().id;

      var diaryData = Diary(
        date: date,
        id: id,
        userId: currentUser?.id,
        breakfast: _mealsId[0],
        lunch: _mealsId[1],
        dinner: _mealsId[2],
        caloriesGoals: currentUser?.calorieGoal,
      ).toMap(); // Convert Diary object to Map

      diaries.doc(id).set(diaryData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logbook")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Welcome to your Logbook!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Please log your meals for each time of the day:",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            Center(
              child: _arraylength > 2
                  ? ElevatedButton(
                      onPressed: () => _addToDiaries(),
                      child: Text("Add to Diaries"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : Container(),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Instructions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "1. Tap on each meal time section to expand and view available recipes.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "2. Tap on the '+' icon next to a recipe to add it to your diaries.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "*Add only one meal for each time of day.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
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
          elevation: isExpanded ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 30,
            ),
            onTap: onTap,
          ),
        ),

        if (isExpanded)
          ListView.separated(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Container(
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
                  onPressed: () => _pushToMealsId(recipe.id!),
                  icon: Icon(Icons.add_rounded, size: 20),
                  label: Text("Add"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

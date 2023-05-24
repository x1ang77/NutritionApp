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
  List<String> _mealsId=[];
  int _arraylength = 0;
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
      debugPrint("${recipe.image?[0]}");
      setState(() {
        if (recipe.mealTime == "morning") {
          _breakfastRecipes.add(recipe);
        }
        if (recipe.mealTime == "afternoon") {
          _lunchRecipes.add(recipe);
        }
        if (recipe.mealTime == "night") {
          _dinnerRecipes.add(recipe);
        }
        _allRecipes.add(recipe);
      });
    }
  }

  _pushToMealsId(String id){
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Breakfast"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _breakfastRecipes.length,
              itemBuilder: (context, index) {
                final breakfastRecipe = _breakfastRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${breakfastRecipe.name}"),
                              Row(
                                children: [
                                  Text("${breakfastRecipe.carbs} cals"),
                                  Text("${breakfastRecipe.grams}g"),
                                  Text("${breakfastRecipe.carbs} carbs"),
                                  Text("${breakfastRecipe.protein} pro"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _pushToMealsId(breakfastRecipe.id!),
                            child: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Text("Lunch"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lunchRecipes.length,
              itemBuilder: (context, index) {
                final lunchRecipe = _lunchRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${lunchRecipe.name}"),
                              Row(
                                children: [
                                  Text("${lunchRecipe.carbs} cals"),
                                  Text("${lunchRecipe.grams}g"),
                                  Text("${lunchRecipe.carbs} carbs"),
                                  Text("${lunchRecipe.protein} pro"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _pushToMealsId(lunchRecipe.id!),
                            child: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Text("Dinner"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dinnerRecipes.length,
              itemBuilder: (context, index) {
                final dinnerRecipe = _dinnerRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${dinnerRecipe.name}"),
                              Row(
                                children: [
                                  Text("${dinnerRecipe.carbs} cals"),
                                  Text("${dinnerRecipe.grams}g"),
                                  Text("${dinnerRecipe.carbs} carbs"),
                                  Text("${dinnerRecipe.protein} pro"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _pushToMealsId(dinnerRecipe.id!),
                            child: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            _arraylength > 2 ?
            ElevatedButton(onPressed: () => _addToDiaries(), child: Text("Add to Diaries")):
                Container()
          ],
        ),
      ),
    );
  }
}

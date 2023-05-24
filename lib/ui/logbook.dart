import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/model/recipe.dart';

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
  int _index = 0;

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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}

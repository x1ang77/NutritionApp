import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _breakfastRecipes = [];
  List<Recipe> _lunchRecipes = [];
  List<Recipe> _dinnerRecipes = [];
  int _index = 0;
  var repo = UserRepoImpl();


  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  _navigateToDetails(String id) {
    context.pushNamed("id", pathParameters: {"id": id});
  }

  _navigateToLogbook(){
    context.push("/logbook");
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

  _addToFavourite(String id) async {
    var user = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentRef = FirebaseFirestore.instance.collection("users").doc(user);
    // Retrieve the document
    var documentSnapshot = await repo.getUserById(user!);

    if (documentSnapshot != null) {
      var array =documentSnapshot.favourite;
      if(array != null){
        if (!array.contains(id)) {
          documentRef.update({
            'favourite': FieldValue.arrayUnion([id])
          }
          );
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Breakfast",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: _breakfastRecipes.length,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() {
                    _index = index;
                  }),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: GestureDetector(
                        onTap: () => _navigateToDetails(_breakfastRecipes[i].id!),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(_breakfastRecipes[i].thumbnail),
                                  Text(_breakfastRecipes[i].name),
                                ],
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: ElevatedButton(
                                  onPressed: () => _addToFavourite(_breakfastRecipes[i].id!),
                                  child: const Icon(Icons.book_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              const Text(
                "Lunch",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: _lunchRecipes.length,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() {
                    _index = index;
                  }),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: GestureDetector(
                        onTap: () => _navigateToDetails(_lunchRecipes[i].id!),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(_lunchRecipes[i].thumbnail),
                                  Text(_lunchRecipes[i].name),
                                ],
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: ElevatedButton(
                                  onPressed: () => _addToFavourite(_lunchRecipes[i].id!),
                                  child: const Icon(Icons.book_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Dinner",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: _dinnerRecipes.length,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() {
                    _index = index;
                  }),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: GestureDetector(
                        onTap: () => _navigateToDetails(_dinnerRecipes[i].id!),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(_dinnerRecipes[i].thumbnail),
                                  Text(_dinnerRecipes[i].name),
                                ],
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: ElevatedButton(
                                  onPressed: () => _addToFavourite(_dinnerRecipes[i].id!),
                                  child: const Icon(Icons.book_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () => _navigateToLogbook(),
          child: Icon(Icons.add_card),
        ),
      ),
    );
  }
}

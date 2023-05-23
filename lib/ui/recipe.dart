import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/recipe.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _breakfastRecipes =[];
  List<Recipe> _lunchRecipes =[];
  List<Recipe> _dinnerRecipes =[];
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe();
  }

  _navigateToDetails(String id){
    context.pushNamed("id", pathParameters: {"id":id});
  }

  Future getRecipe() async{
    var collection = FirebaseFirestore.instance.collection("meals");
    var querySnapshot = await collection.get();
    for(var item in querySnapshot.docs){
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      debugPrint("${recipe.image?[0]}");
      setState(() {
        if(recipe.mealTime == "morning"){
          _breakfastRecipes.add(recipe);
        }
        if(recipe.mealTime == "afternoon"){
          _lunchRecipes.add(recipe);
        }
        if(recipe.mealTime == "night"){
          _dinnerRecipes.add(recipe);
        }
        _allRecipes.add(recipe);
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Breakfast"),
          SizedBox(
            height: 200,
            child:PageView.builder(
                itemCount: _breakfastRecipes.length,
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() {
                  _index = index;
                }),
                itemBuilder: (_,i){
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: GestureDetector(
                      onTap: () => _navigateToDetails(_breakfastRecipes[i].id!),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(_breakfastRecipes[i].thumbnail),
                              const Text("is it working"),
                              const SizedBox(height:10),
                            ],
                          ),
                        ),
                      ),
                    )
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutrition_app/core/custom_exception.dart';
import 'package:nutrition_app/data/model/recipe.dart';
import 'package:nutrition_app/data/repository/recipe/recipe_repository.dart';

class RecipeRepoImpl extends RecipeRepo {
  final collection = FirebaseFirestore.instance.collection('recipes');

  @override
  Future<Recipe> getRecipe(String id) async {
    try {
      // var docSnapshot = await collection.doc(id).get();
      // if (docSnapshot.exists) {
      //   var data = docSnapshot.data();
      //   var recipe = Recipe.fromMap(data!);
      //   return recipe;
      // }
      // throw CustomException("No such recipe exists");

      var querySnapshot = await collection.where("id", isEqualTo: id).get();
      var data = querySnapshot.docs.single.data();
      var recipe = Recipe.fromMap(data);
      return recipe;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
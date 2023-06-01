import '../../model/recipe.dart';

abstract class RecipeRepo {
  Future<Recipe> getRecipe(String id);
}
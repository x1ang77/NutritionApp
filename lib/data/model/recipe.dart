class Recipe {
  final String? id;
  final String name;
  final double calorie;
  final double carbohydrate;
  final double fat;
  final double protein;
  final List<String> ingredients;
  final List<String> steps;

  static const String tableName = "recipes";

  Recipe({
    this.id, required this.name, required this.calorie,
    required this.carbohydrate, required this.fat, required this.protein,
    required this.ingredients, required this.steps
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "calories": calorie,
      "carbohydrate": carbohydrate,
      "fat": fat,
      "protein": protein,
      "ingredients": ingredients,
      "steps": steps
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      calorie: map["calories"],
      carbohydrate: map["carbohydrate"],
      fat: map["fat"],
      protein: map["protein"],
      ingredients: map["ingredients"],
      steps: map["steps"]
    );
  }
}
class Recipe {
  final int? id;
  final String name;
  final int calories;
  final List<String> ingredients;
  final List<String> steps;

  static const String tableName = "recipes";

  Recipe({
    this.id, required this.name, required this.calories,
    required this.ingredients, required this.steps
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "calories": calories,
      "ingredients": ingredients,
      "steps": steps
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      calories: map["calories"],
      ingredients: map["ingredients"],
      steps: map["steps"]
    );
  }
}
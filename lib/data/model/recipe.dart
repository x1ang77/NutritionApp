class Recipe {
  final String? id;
  final String name;
  final double calorie;
  final List<String> ingredients;
  final List<String> steps;

  static const String tableName = "recipes";

  Recipe({
    this.id, required this.name, required this.calorie,
    required this.ingredients, required this.steps
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "calories": calorie,
      "ingredients": ingredients,
      "steps": steps
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      calorie: map["calories"],
      ingredients: map["ingredients"],
      steps: map["steps"]
    );
  }
}
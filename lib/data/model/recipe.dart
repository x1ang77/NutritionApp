class Recipe {
  final String id;
  final String name;
  final String thumbnail;
  final String description;
  final double calorie;
  final double carb;
  final double protein;
  final double fat;
  final List<String> ingredients;
  final List<String> steps;
  final String mealTime;

  static const String tableName = "recipes";

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.calorie,
    required this.carb,
    required this.protein,
    required this.fat,
    required this.ingredients,
    required this.steps,
    required this.mealTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "thumbnail": thumbnail,
      "description": description,
      "calorie": calorie,
      "carb": carb,
      "protein": protein,
      "fat": fat,
      "ingredients": ingredients,
      "steps": steps,
      "meal_time": mealTime
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      thumbnail: map["thumbnail"],
      description: map["description"],
      calorie: map["calorie"],
      carb: map["carb"],
      protein: map["protein"],
      fat: map["fat"],
      ingredients: (map["ingredients"] as List<dynamic>).cast<String>(),
      steps: (map["steps"] as List<dynamic>).cast<String>(),
      mealTime: map["meal_time"]
    );
  }
}

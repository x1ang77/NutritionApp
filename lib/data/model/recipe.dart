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
      calorie: map["calorie"] is int ? map["calorie"].toDouble() : map["calorie"],
      carb: map["carb"] is int ? map["carb"].toDouble() : map["carb"],
      protein: map["protein"] is int ? map["protein"].toDouble() : map["protein"],
      fat: map["fat"] is int ? map["fat"].toDouble() : map["fat"],
      ingredients: (map["ingredients"] as List<dynamic>).cast<String>(),
      steps: (map["steps"] as List<dynamic>).cast<String>(),
      mealTime: map["meal_time"]
    );
  }
}

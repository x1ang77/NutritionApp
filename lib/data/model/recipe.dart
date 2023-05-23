class Recipe {
  final String? id;
  final String name;
  final String mealTime;
  final String thumbnail;
  final String desc;
  final double? carbs;
  final double? grams;
  final double? protein;
  final double? calories;
  final List<String>? image;
  final List<String>? ingredients;
  final List<String>? steps;

  static const String tableName = "recipes";

  Recipe({
    this.id,
    required this.name,
    required this.mealTime,
    required this.thumbnail,
    required this.desc,
    this.carbs,
    this.grams,
    this.protein,
    this.calories,
    this.image,
    this.ingredients,
    this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "mealTime": mealTime,
      "thumbnail": thumbnail,
      "desc": desc,
      "carbs": carbs,
      "grams": grams,
      "protein": protein,
      "calories": calories,
      "image": image,
      "ingredients": ingredients,
      "steps": steps,
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      mealTime: map["mealTime"],
      thumbnail: map["thumbnail"],
      desc: map["desc"],
      carbs: map["carbs"],
      grams: map["grams"],
      protein: map["protein"],
      calories: map["calories"],
      image: (map["image"] as List<dynamic>?)?.cast<String>(),
      ingredients: (map["ingredients"] as List<dynamic>?)?.cast<String>(),
      steps: (map["steps"] as List<dynamic>?)?.cast<String>(),
    );
  }
}

class Diary {
  final String? id;
  final String? userId;
  final String? date;
  final List<String>? meals;
  // final List<String>? lunch;
  // final List<String>? dinner;
  final double? caloriesGoal;
  final double? caloriesConsumed;
  final double? carbGoal;
  final double? proteinGoal;
  final double? fatGoal;

  static const String tableName = "diaries";

  Diary({
    this.id, this.userId, this.date,
    this.meals, this.caloriesGoal = 0,
    // this.lunch, this.dinner,
    this.caloriesConsumed = 0,
    this.carbGoal = 0,
    this.proteinGoal = 0,
    this.fatGoal = 0
  });

  Map<String ,dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "date": date,
      "meals": meals,
      // "lunch": lunch,
      // "dinner": dinner,
      "calories_goal": caloriesGoal,
      "calories_consumed": caloriesConsumed,
      "carb_goal": carbGoal,
      "protein_goal": proteinGoal,
      "fat_goal": fatGoal,
    };
  }

  static Diary fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map["id"],
      userId: map["user_id"],
      date: map["date"],
      meals: (map["meals"] as List<dynamic>?)?.cast<String>(),
      // lunch: (map["lunch"] as List<dynamic>?)?.cast<String>(),
      // dinner: (map["dinner"] as List<dynamic>?)?.cast<String>(),
      caloriesGoal: map["calories_goal"] is int ? map["calories_goal"].toDouble() : map["calories_goal"],
      caloriesConsumed: map["calories_consumed"] is int ? map["calories_consumed"].toDouble() : map["calories_consumed"],
      carbGoal: map["carb_goal"] is int ? map["carb_goal"].toDouble() : map["carb_goal"],
      proteinGoal: map["protein_goal"] is int ? map["protein_goal"].toDouble() : map["protein_goal"],
      fatGoal: map["fat_goal"] is int ? map["fat_goal"].toDouble() : map["fat_goal"],
    );
  }
}
class Diary {
  final String? id;
  final String? userId;
  final String? date;
  final List<String>? meals;
  final double? caloriesGoal;
  final double? carbGoal;
  final double? proteinGoal;
  final double? fatGoal;

  static const String tableName = "diaries";

  Diary({
    this.id, this.userId, this.date,
    this.meals, this.caloriesGoal = 0,
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
      "calories_goal": caloriesGoal,
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
      caloriesGoal: map["calories_goal"] is int ? map["calories_goal"].toDouble() : map["calories_goal"],
      carbGoal: map["carb_goal"] is int ? map["carb_goal"].toDouble() : map["carb_goal"],
      proteinGoal: map["protein_goal"] is int ? map["protein_goal"].toDouble() : map["protein_goal"],
      fatGoal: map["fat_goal"] is int ? map["fat_goal"].toDouble() : map["fat_goal"],
    );
  }
}
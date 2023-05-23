class Diary {
  final String? id;
  final String? userId;
  final String date;
  final String breakfast;
  final String lunch;
  final String dinner;
  final double? caloriesGoals;
  final double? caloriesConsumed;

  static const String tableName = "diaries";

  Diary({
    this.id, this.userId, required this.date,
    required this.breakfast, required this.lunch,
    required this.dinner,  this.caloriesGoals,
    this.caloriesConsumed = 0
  });

  Map<String ,dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "date": date,
      "breakfast": breakfast,
      "lunch": lunch,
      "dinner": dinner,
      "calories_goals": caloriesGoals,
      "calories_consumed": caloriesConsumed,
    };
  }

  static Diary fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map["id"],
      userId: map["user_id"],
      date: map["date"],
      breakfast: map["breakfast"],
      lunch: map["lunch"],
      dinner: map["dinner"],
      caloriesGoals: map["calories_goals"],
      caloriesConsumed: map["calories_consumed"],
    );
  }
}
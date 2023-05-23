class Diary {
  final String? id;
  final String? userId;
  final String date;
  final List<String>? breakfast;
  final List<String>? lunch;
  final List<String>? dinner;
  final List<String>? snack;

  final double? caloriesRemaining;
  final double? caloriesConsumed;
  final double? caloriesBurned;

  static const String tableName = "diaries";

  Diary({
    this.id, this.userId, required this.date, this.breakfast,
    this.lunch, this.dinner, this.snack, this.caloriesRemaining,
    this.caloriesConsumed = 0, this.caloriesBurned = 0
  });

  Map<String ,dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "date": date,
      "breakfast": breakfast,
      "lunch": lunch,
      "dinner": dinner,
      "snack": snack,
      "calories_remaining": caloriesRemaining,
      "calories_consumed": caloriesConsumed,
      "calories_burned": caloriesBurned
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
      snack: map["snack"],
      caloriesRemaining: map["calories_remaining"],
      caloriesConsumed: map["calories_consumed"],
      caloriesBurned: map["calories_burned"]
    );
  }
}
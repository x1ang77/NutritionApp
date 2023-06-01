import '../../model/diary.dart';

abstract class DiaryRepo {
  Future<void> addToDiary
      (String userId, String date, List<String>? meals,
      double caloriesGoal, double carbGoal, double proteinGoal,
      double fatGoal, String? meal,
      );
  Future<Diary> getDiary(String userId, String date);
  Future<void> removeMealFromDiary(String diaryId, String mealId);
}
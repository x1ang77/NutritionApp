import '../../model/diary.dart';

abstract class DiaryRepo {
  Future<Diary> getDiary(String userId, String date);
}
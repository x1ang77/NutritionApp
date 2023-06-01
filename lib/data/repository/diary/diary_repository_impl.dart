import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutrition_app/data/model/diary.dart';
import 'package:nutrition_app/data/repository/diary/diary_repository.dart';

class DiaryRepoImpl extends DiaryRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection("diaries");

  @override
  Future addToDiary(
      String userId, String date, List<String>? meals,
      double caloriesGoal, double carbGoal, double proteinGoal,
      double fatGoal, String? meal,
      ) async {
    var querySnapshot = await collection
        .where("user_id", isEqualTo: userId)
        .where("date", isEqualTo: date)
        .limit(1)
        .get();

    var id = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs[0].id
        : collection.doc().id;

    if (querySnapshot.docs.isEmpty) {
      var diary = Diary(
          id: id,
          userId: userId,
          date: date,
          meals: meals,
          caloriesGoal: caloriesGoal,
          carbGoal: carbGoal,
          proteinGoal: proteinGoal,
          fatGoal: fatGoal
      );
      await collection.doc(id).set(diary.toMap());
    } else {
      final documentRef = collection.doc(id);
      await documentRef.update({'meals': FieldValue.arrayUnion([meal])});
    }
  }

  @override
  Future<Diary> getDiary(String userId, String date) async {
    try {
      var querySnapshot = await collection
          .where("user_id", isEqualTo: userId)
          .where("date", isEqualTo: date)
          .get();
      var data = querySnapshot.docs.single.data();
      debugPrint(data.toString());
      var diary = Diary.fromMap(data);
      return diary;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
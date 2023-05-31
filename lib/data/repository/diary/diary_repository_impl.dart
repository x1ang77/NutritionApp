import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutrition_app/data/model/diary.dart';

class DiaryRepoImpl {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection("diaries");

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
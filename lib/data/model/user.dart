import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class User {
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? image;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final String? diet;
  final double? calorieGoal;
  final double? carbGoal;
  final double? proteinGoal;
  final double? fatGoal;

  static const String tableName = "users";

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.image,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.diet,
    this.calorieGoal = 2000,
    this.carbGoal = 600,
    this.proteinGoal = 200,
    this.fatGoal = 100,
  });

  User copyWith({String? username, String? email, String? password,}) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    final String hashedPassword = md5.convert(utf8.encode(password)).toString();
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": hashedPassword,
      "image": image,
      "gender": gender,
      "age": age,
      "height": height,
      "weight": weight,
      "diet": diet,
      "calorie_goal": calorieGoal ?? 2000,
      "carb_goal": carbGoal ?? 600,
      "protein_goal": proteinGoal ?? 200,
      "fat_goal": fatGoal ?? 100
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      username: map["username"],
      email: map["email"],
      password: map["password"],
      image: map["image"],
      gender: map["gender"],
      age: map["age"] ?? 0,
      height: map["height"] ?? 0.0,
      weight: map["weight"] ?? 0.0,
      diet: map["diet"] ?? '',
      calorieGoal: map["calorie_goal"] ?? 0.0,
      carbGoal: map["carb_goal"] ?? 0.0,
      proteinGoal: map["protein_goal"] ?? 0.0,
      fatGoal: map["fat_goal"] ?? 0.0
    );
  }
}

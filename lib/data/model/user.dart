import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final String? id;
  final String firstName;
  final String lastName;
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
  final List<String>? favourite;
  final bool completedOnboarding;

  static const String tableName = "users";

  User({
    this.id,
    required this.firstName,
    required this.lastName,
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
    this.favourite = const [],
    this.completedOnboarding = false
  });

  User copyWith({
    String? id, String? firstName, String? lastName, String? email, String? password, String? image,
    String? gender, int? age, double? height, double? weight, String? diet, double? calorieGoal,
    double? carbGoal, double? proteinGoal, double? fatGoal, List<String>? favorite, bool? completedOnboarding
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      diet: diet ?? this.diet,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      carbGoal: carbGoal ?? this.carbGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      favourite: favourite,
      completedOnboarding: completedOnboarding ?? this.completedOnboarding
    );
  }

  Map<String, dynamic> toMap() {
    final String hashedPassword = md5.convert(utf8.encode(password)).toString();
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
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
      "fat_goal": fatGoal ?? 100,
      "favourite": favourite ?? [],
      "completed_onboarding": completedOnboarding
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
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
      fatGoal: map["fat_goal"] ?? 0.0,
      favourite: (map["favourite"] as List<dynamic>?)?.cast<String>(),
      completedOnboarding: map["completed_onboarding"]
    );
  }
}

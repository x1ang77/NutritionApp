import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class User {
  final String? id;
  final String username;
  final String email;
  final String password;
  String? image;
  final String gender;
  final int age;
  final double height;
  final double weight;
  final String? diet;
  final int? calorieIntake;

  static const String tableName = "users";

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.image,
    this.gender = '',
    this.age = 0,
    this.height = 0.0,
    this.weight = 0.0,
    this.diet = '',
    this.calorieIntake = 0,
  });

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
      "calorie_intake": calorieIntake
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
      calorieIntake: map["calorie_intake"] ?? 0,
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final Uint8List? image;
  final int gender;
  final int age;
  final String height;
  final String weight;
  final String? diet;
  final int? calorieIntake;

  static const String tableName = "users";

  User({
    this.id, required this.username, required this.email, required this.password,
    this.image, required this.gender, required this.age, required this.height, required this.weight, this.diet,
    this.calorieIntake
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
      age: map["age"],
      height: map["height"],
      weight: map["weight"],
      diet: map["diet"],
      calorieIntake: map["calorie_intake"]
    );
  }
}

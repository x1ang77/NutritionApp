import 'package:nutrition_app/data/model/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepo {
  Future<void> checkEmailInFirebase(String email);
  Future<void> login(String email, String password);
  Future<void> register(String firstName, String lastName, String email, String password);
  User? getCurrentUser();
  Future<user_model.User?> getUserById(String userId);
  Future<void> updateUserProfile(String userId, String image);
  Future<void> logout();
}
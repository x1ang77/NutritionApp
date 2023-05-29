import 'package:nutrition_app/data/model/user.dart';

abstract class UserRepo {
  Future<void> checkEmailInFirebase(String email);
  Future<void> login(String email, String password);
  Future<void> register(String username, String email, String password);
  Future<User?> getUserById(String userId);
  Future<void> updateUserProfile(String userId, String image);
  Future<void> logout();
}
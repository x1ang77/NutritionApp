import 'package:nutrition_app/data/model/user.dart';

abstract class UserRepo {
  Future<void> login(String email, String password);
  Future<void> register(User user);
}
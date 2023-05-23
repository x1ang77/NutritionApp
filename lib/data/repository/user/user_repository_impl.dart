import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/data/model/user.dart' as user_model;
import 'package:nutrition_app/data/repository/user/user_repository.dart';

class UserRepoImpl extends UserRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection("users");

  // Future<User> getUser() async {
  // }

  @override
  Future<bool> checkEmailInFirebase(String email) async {
    try {
      final list = await firebaseAuth.fetchSignInMethodsForEmail(email);
      if (list.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> register(user_model.User user) async {
    try {
      final list = await firebaseAuth.fetchSignInMethodsForEmail(user.email);

      // if (list.isEmpty) {
      //   // Return true because there is an existing
      //   // user using the email address
      //   _showSnackbar("Email in use", Colors.red);
      // }
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
      final _user = userCredential.user;
      final hashedPassword = md5.convert(utf8.encode(user.password)).toString();
      await collection.doc(_user?.uid).set({
        'name': user.username,
        'email': user.email,
        'password': hashedPassword,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutrition_app/data/model/user.dart' as user_model;
import 'package:nutrition_app/data/repository/user/user_repository.dart';

import '../../../core/custom_exception.dart';

class UserRepoImpl extends UserRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final collection = FirebaseFirestore.instance.collection("users");

  @override
  Future<bool> checkEmailInFirebase(String email) async {
    try {
      final list = await firebaseAuth.fetchSignInMethodsForEmail(email);
      if (list.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error checking email: $e");
      throw CustomException("Error encountered when checking email");
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
      debugPrint("Error logging in: $e");
      throw CustomException("Error encountered when logging in");
    }
  }

  @override
  Future<void> register(
      String firstName, String lastName, String email, String password
      ) async {
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      final firebaseUser = userCredential.user;
      final userUID = firebaseUser?.uid;
      final hashedPassword = md5.convert(utf8.encode(password)).toString();
      final user = user_model.User(id: userUID, firstName: firstName, lastName: lastName, email: email, password: hashedPassword);
      await collection.doc(userUID).set(user.toMap());
    } catch (e) {
      debugPrint("Error registering: $e");
      throw CustomException("Error encountered when registering");
    }
  }

  @override
  User? getCurrentUser() {
    try {
      var user = firebaseAuth.currentUser;
      return user;
    } catch (e) {
      debugPrint("Error getting user by the ID: $e");
      throw CustomException("Error encountered when getting user");
    }
  }

  @override
  Future<user_model.User?> getUserById(String userId) async {
    try {
      var querySnapshot = await collection
          .where("id", isEqualTo: userId)
          .get();
      var data = querySnapshot.docs.single.data();
      debugPrint(data.toString());
      var user = user_model.User.fromMap(data);
      return user;
    } catch (e) {
      debugPrint("Error getting user by the ID: $e");
      throw CustomException("Error encountered when getting user");
    }
  }

  @override
  Future<void> updateUserProfile(String userId, String image) async {
    try {
      await collection.doc(userId).update({"image": image});
    } catch(e) {
      debugPrint("Error updating image: $e");
      throw CustomException("Error encountered when updating image");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  // Future<String?> uploadImageToFirebase(File imageFile) async {
  //   try {
  //     // Create a unique filename for the image
  //     fileName = DateTime.now().toString();
  //
  //     // Create a reference to the Firebase Storage location where you want to store the image
  //     final Reference storageReference =
  //     FirebaseStorage.instance.ref().child('images/$fileName');
  //
  //     // Upload the image file to Firebase Storage
  //     await storageReference.putFile(imageFile);
  //
  //     // Get the download URL of the uploaded image
  //     downloadUrl = await storageReference.getDownloadURL();
  //
  //     // Return the download URL
  //     debugPrint("Am i getting here?");
  //     return downloadUrl;
  //   } catch (e) {
  //     // Handle any errors that occur during the upload process
  //     debugPrint('Failed to upload image: $e');
  //     return '';
  //   }
  // }
}
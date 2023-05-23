import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../data/model/user.dart' as user_model;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var repo = UserRepoImpl();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? userEmail;
  String? userName;
  List<user_model.User> users = [];

  File? image;
  String base64ImageString = "";
  user_model.User? _user;
  String? downloadUrl;
  String? fileName;

  Uint8List getImageBytes() {
    return base64Decode(base64ImageString);
  }

  Future<void> _savePic() async {
    debugPrint('Image: $image');

    User? user = FirebaseAuth.instance.currentUser;

    if (_user!= null && image != null && user != null) {
      debugPrint('Image and user image are not null');
       downloadUrl = await uploadImageToFirebase(image!);

      debugPrint('Download URL: $downloadUrl');

      // Update the user's profile in Firebase Firestore with the download URL
      if (downloadUrl!.isNotEmpty) {
        await repo.updateUserProfile(user.uid, fileName!);
        debugPrint('User profile updated');
      } else {
        debugPrint('Download URL is empty');
      }
    } else {
      debugPrint('Image or user image is null');
    }
  }


  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      debugPrint('Image picked: $imageFile');
      setState(() {
        this.image = imageFile;
      });
    } else {
      debugPrint('Image not picked');
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a unique filename for the image
      fileName = DateTime.now().toString();

      // Create a reference to the Firebase Storage location where you want to store the image
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the image file to Firebase Storage
      await storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      downloadUrl = await storageReference.getDownloadURL();

      // Return the download URL
      debugPrint("Am i getting here?");
      return downloadUrl;

    } catch (e) {
      // Handle any errors that occur during the upload process
      debugPrint('Failed to upload image: $e');
      return '';
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    getUser();
  }

  Future getUser() async {
    // final collection = await FirebaseFirestore.instance.collection("users").get();
    // var data = collection.docs;
    // var user = data.elementAt(0).data();
    // var currentUser = user_model.User.fromMap(user);
    // _user = currentUser;
    // debugPrint("${_user?.email}");
    User? user = FirebaseAuth.instance.currentUser;
    var currentUser = await repo.getUserById("fpPvRnd4J9UwVhIw3s7xBltppu03");
    setState(() {
      _user = currentUser;
    });
    final Reference storageReference = FirebaseStorage.instance.ref().child('images/${_user?.image}');
    var temp = await storageReference.getDownloadURL();
    debugPrint(temp.toString());
    setState(() {
      downloadUrl = temp;
    });
  }

  // Future fetchUserData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //
  //     if (snapshot.exists) {
  //       Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
  //       // String name = userData['name'];
  //       String password = userData['password'];
  //       setState(() {
  //         userEmail = user.email;
  //         // userName = name;
  //         // _user = user_model.User(
  //         //   // Assign other fields from the fetched user data if needed
  //         //   id: user.uid,
  //         //   // username: name,
  //         //   email: userEmail.toString(),
  //         //   password: password
  //         // );
  //         // debugPrint(name);
  //       });
  //     }
  //   }
  // }

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

   User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reauthenticate the user with their current password
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        // Change the password
        await user.updatePassword(newPassword);
        debugPrint('Password changed successfully');
      } catch (e) {
        debugPrint('Failed to change password: $e');

        // Show a snackbar indicating that the current password is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect current password'),
          ),
        );
      }
    } else {
      debugPrint('User is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
            Text(userEmail ?? 'No user signed in'),
            Text(userName ?? "GG"),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: _savePic,
              child: const Text("Save Image"),
            ),
            Container(
              child: image != null
                  ? Image.file(image!)
                  : _user?.image != null
                  ? Image.network(downloadUrl ?? "")
                  : Container(),
            ),
            // Container(
            //     child: Image.network(downloadUrl ?? "")
            // ),
          ],
        ),
      ),
    );
  }
}


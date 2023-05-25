import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_app/core/custom_exception.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../data/model/user.dart' as user_model;
import 'component/snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var repo = UserRepoImpl();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newCalorieGoalController = TextEditingController();

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

    if (_user != null && image != null && user != null) {
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

  navigateToLogin() {
    context.go('/login');
  }

  _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      navigateToLogin();
    } catch (e) {
      // An error occurred while signing out
      debugPrint('Error signing out: $e');
      // Show an error message or handle the error accordingly
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      setState(() {
        this.image = imageFile;
      });
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Do you want to save this image?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _savePic();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Confirm"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    this.image = null;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    } else {
      debugPrint('Image not picked');
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a unique filename for the image
      fileName = DateTime.now().toString();

      // Create a reference to the Firebase Storage location where you want to store the image
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

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
    _newCalorieGoalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    var currentUser = await repo.getUserById(user!.uid);
    setState(() {
      _user = currentUser;
    });
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${_user?.image}');
    var temp = await storageReference.getDownloadURL();
    debugPrint(temp.toString());
    setState(() {
      downloadUrl = temp;
    });
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Change Password", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () => _changePassword(context),
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _changePassword(context) {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      user.reauthenticateWithCredential(EmailAuthProvider.credential(
              email: user.email!, password: currentPassword))
          .then((authResult) {
        user.updatePassword(newPassword).then((_) {
          debugPrint('Password changed successfully');
          // Show a success message or perform any additional actions
          // Clear the text fields after the password change
          _currentPasswordController.clear();
          _newPasswordController.clear();
          // Close the dialog
          context.pop();
        }).catchError((error) {
          throw CustomException("Password is wrong");
          // Show an error message to the user
        });
      }).catchError((error) {
        showSnackbar(context, error.toString(), Colors.red);
        debugPrint('Failed to reauthenticate user: $error');
        // Show an error message to the user indicating that the current password is incorrect
      });
    } else {
      print('User is not signed in');
    }
  }

  void _calorieDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Edit Calorie Goal", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _user?.calorieGoal?.toInt().toString() ?? "",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _newCalorieGoalController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'New Goal',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 12.0),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {_updateCalorieGoal();
                        Navigator.of(context).pop();
                        _newCalorieGoalController.clear();
                          },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // void _changePassword() {
  //   // Show the dialog
  //   _showChangePasswordDialog(context);
  // }

  void _updateCalorieGoal() {

    String newCalorieGoal = _newCalorieGoalController.text;
    print('New Calorie Goal: $newCalorieGoal');
    double parsedCalorieGoal = double.tryParse(newCalorieGoal) ?? 0.0;
    print('Parsed Calorie Goal: $parsedCalorieGoal');

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
     FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'calorie_goal': parsedCalorieGoal})
          .then((_) {
        print('Calorie goal updated successfully');
        // Update the _user object with the new calorie goal
        // Close the dialog
        // Show a success Snackbar or perform any additional actions
      }).catchError((error) {
        print('Failed to update calorie goal: $error');
        // Show an error message to the user
      });

    } else {
      print('User is not signed in');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 115,
                              child: CircleAvatar(
                                radius: 110,
                                backgroundImage: image != null
                                    ? FileImage(image!)
                                    : _user?.image != null
                                        ? Image.network(downloadUrl ?? "").image
                                        : AssetImage("/assets/images/nuts.jpg"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 70,
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            child: Icon(Icons.edit),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text("@${_user?.username ?? ""}"),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _showChangePasswordDialog,
                      child: Text('Change Password'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {_calorieDialog();},
                          child: Text('Edit Calorie Goal'),
                        ),
                        SizedBox(width: 10.0),
                        // ElevatedButton(
                        //   onPressed: _changePassword,
                        //   child: Text('Edit Macro Goals'),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

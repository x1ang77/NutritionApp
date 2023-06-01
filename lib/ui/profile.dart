import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/core/custom_exception.dart';
import 'package:nutrition_app/custom_icons.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

import '../data/model/user.dart' as user_model;
import 'component/snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userRepo = UserRepoImpl();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newCalorieGoalController = TextEditingController();
  final _fatGoalController = TextEditingController();
  final _proteinGoalController = TextEditingController();
  final _carbGoalController = TextEditingController();
  final _nameController = TextEditingController();

  String? userEmail;
  String? userName;
  List<user_model.User> users = [];

  File? image;
  String base64ImageString = "";
  user_model.User? _user;
  String? downloadUrl;
  String? fileName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newCalorieGoalController.dispose();
    super.dispose();
  }

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
        await userRepo.updateUserProfile(user.uid, fileName!);
        debugPrint('User profile updated');
      } else {
        debugPrint('Download URL is empty');
      }
    } else {
      debugPrint('Image or user image is null');
    }
  }

  void navigateToLogin() {
    context.go('/login');
  }

  Future<void> _logout(context) async {
    try {
      await userRepo.logout();
      navigateToLogin();
      showSnackbar(context, "Logged out successfully", Colors.green);
    } catch (e) {
      debugPrint('Error signing out: $e');
      showSnackbar(context, "Failed to logout", Colors.green);
    }
  }

  void _pickImage() async {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    this.image = null;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  _savePic();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Confirm"),
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
      fileName = DateFormat("y_M_d_Hms").format(DateTime.now());

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

  Future getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    var currentUser = await userRepo.getUserById(user!.uid);
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
    getUser();
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    // focusNode: _passwordFocusNode,
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                        onPressed: () => _changePassword(),
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

  void _changePassword() {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      user
          .reauthenticateWithCredential(EmailAuthProvider.credential(
              email: user.email!, password: currentPassword))
          .then((authResult) {
        user.updatePassword(newPassword).then((_) {
          debugPrint('Password changed successfully');
          showSnackbar(context, "Password changed successfully", Colors.green);
          // Show a success message or perform any additional actions
          // Clear the text fields after the password change
          _currentPasswordController.clear();
          _newPasswordController.clear();
          // Close the dialog
          Navigator.of(context).pop();
        }).catchError((error) {
          throw CustomException("Password is wrong");
          // Show an error message to the user
        });
      }).catchError((error) {
        if (_currentPasswordController.text.isEmpty ||
            _newPasswordController.text.isEmpty) {
          showSnackbar(context, "Please fill in both fields before updating", Colors.red);
        } else {
          showSnackbar(context, "Failed to change password", Colors.red);
        }
        debugPrint('Failed to reauthenticate user: $error');
        // Show an error message to the user indicating that the current password is incorrect
      });
    } else {
      print('User is not signed in');
    }
  }

  void _showUpdateNameDialog() {
    getUser();
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
                  Text("Update Name", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
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
                        onPressed: () {
                          _updateName();
                          Navigator.of(context).pop();
                          _nameController.clear();
                        },
                        child: Text('Update'),
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

    // Set the initial value of the text field controller
    _nameController.text = _user?.firstName ?? '';
  }

  void _updateName() {
    getUser();
    String newName = _nameController.text;
    debugPrint('New Name: $newName');

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'first_name': newName}).then((_) {
        debugPrint('Name updated successfully');
        // Show a success message to the user
        showSnackbar(context, "Name updated successfully", Colors.green);
        // Clear the text field
        _nameController.clear();
      }).catchError((error) {
        debugPrint('Failed to update name: $error');
        // Show an error message to the user
        showSnackbar(context, "Failed to update name", Colors.red);
      });
    } else {
      debugPrint('User is not signed in');
    }
  }

  void _macrosDialog() {
    getUser();
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
                  Text("Edit Macro Goals", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _carbGoalController,
                    decoration: InputDecoration(
                      labelText: 'Carb Goal',
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _fatGoalController,
                    decoration: InputDecoration(
                      labelText: 'Fat Goal',
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _proteinGoalController,
                    decoration: InputDecoration(
                      labelText: 'Protein Goal',
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
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
                        onPressed: () {
                          _updateMacroGoals();
                          Navigator.of(context).pop();
                          _carbGoalController.clear();
                          _fatGoalController.clear();
                          _proteinGoalController.clear();
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
    _carbGoalController.text = _user?.carbGoal?.toStringAsFixed(0) ?? '';
    _fatGoalController.text = _user?.fatGoal?.toStringAsFixed(0) ?? '';
    _proteinGoalController.text = _user?.proteinGoal?.toStringAsFixed(0) ?? '';
  }

  void _updateMacroGoals() {
    getUser();
    String carbGoal = _carbGoalController.text;
    String fatGoal = _fatGoalController.text;
    String proteinGoal = _proteinGoalController.text;

    // Parse the values and update the macro goals in the database
    double parsedCarbGoal = double.tryParse(carbGoal) ?? 0.0;
    double parsedFatGoal = double.tryParse(fatGoal) ?? 0.0;
    double parsedProteinGoal = double.tryParse(proteinGoal) ?? 0.0;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'carb_goal': parsedCarbGoal,
        'fat_goal': parsedFatGoal,
        'protein_goal': parsedProteinGoal,
      })
          .then((_) {
        debugPrint('Macro goals updated successfully');
        showSnackbar(context, "Updated macro goals", Colors.green);
        // Perform any additional actions or show a success Snackbar
      })
          .catchError((error) {
        debugPrint('Failed to update macro goals: $error');
        // Show an error message to the user
      });
    } else {
      debugPrint('User is not signed in');
    }

    _carbGoalController.clear();
    _fatGoalController.clear();
    _proteinGoalController.clear();
  }

  void _calorieDialog() {
    getUser();
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
                        onPressed: () {
                          _updateCalorieGoal();
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

  void _updateCalorieGoal() {
    getUser();
    String newCalorieGoal = _newCalorieGoalController.text;
    debugPrint('New Calorie Goal: $newCalorieGoal');
    double parsedCalorieGoal = double.tryParse(newCalorieGoal) ?? 0.0;

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'calorie_goal': parsedCalorieGoal}).then((_) {
        debugPrint('Calorie goal updated successfully');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text('Calorie goal updated successfully'),
        //   ),
        // );
        showSnackbar(context, "Updated calorie goal", Colors.green);
        // Update the _user object with the new calorie goal
        // Close the dialog
        // Show a success Snackbar or perform any additional actions
      }).catchError((error) {
        debugPrint('Failed to update calorie goal: $error');
        // Show an error message to the user
      });
    } else {
      debugPrint('User is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          Container(
            height: 275,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightGreenAccent, Colors.green.shade400, Colors.green.shade700],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              // Text("My Profile", style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 16.0),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 85,
                        backgroundImage: image != null
                            ? FileImage(image!)
                            : _user?.image != null
                            ? Image.network(downloadUrl ?? "").image
                            : const AssetImage("assets/images/empty_profile_image.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 100,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.green.shade700,
                        padding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                "${_user?.firstName ?? ""} ${_user?.lastName ?? ""}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50.0),
              Expanded(
                child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Profile Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          onTap: _showUpdateNameDialog,
                          leading: const Icon(Icons.font_download_rounded),
                          minLeadingWidth : 10,
                          title: const Text('Name'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          onTap: _showChangePasswordDialog,
                          leading: const Icon(Icons.lock),
                          minLeadingWidth : 10,
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          onTap: _calorieDialog,
                          leading: const Icon(Icons.fastfood),
                          minLeadingWidth : 10,
                          title: const Text('Calorie Goal'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          onTap: _macrosDialog,
                          leading: const Icon(Icons.sports_gymnastics),
                          minLeadingWidth : 10,
                          title: const Text('Macros Goal'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: ListTile(
                          onTap: () => _logout(context),
                          leading: const Icon(Icons.logout),
                          minLeadingWidth : 10,
                          title: const Text('Logout'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                        // child: listTile(
                        //     () => _logout(context),
                        //   const Icon(Icons.logout),
                        //   "Logout",
                        //   const Icon(Icons.keyboard_arrow_right)
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ],
      ),
    );
  }
}

ListTile listTile(void Function() onTap, Widget leadingIcon, String title, Widget trailingIcon) {
  return ListTile(
    onTap: onTap,
    leading: leadingIcon,
    title: Text(title),
    trailing: trailingIcon,
  );
}
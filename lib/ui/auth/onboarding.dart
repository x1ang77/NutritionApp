import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/user.dart' as user_model;
import '../../data/repository/user/user_repository_impl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var repo = UserRepoImpl();
  user_model.User? _user;
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final List<String> items = [
    'Male',
    'Female',
  ];

  final List<String> items2 = [
    'Keto',
    'Vegetarian',
    'Pescatarian',
    'Mediterranean'
  ];

  String? selectedValue;
  String? selectedValue2;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  List<double> _getCustomItems2Heights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items2.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    var currentUser = await repo.getUserById(user!.uid);
    setState(() {
      _user = currentUser;
    });
  }

  _navigateToHome() {
    context.go("/home");
  }

  void saveUserInformation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      // User not retrieved yet, handle accordingly
      return;
    }

    // Validate the inputs and save the user information
    final String age = _ageController.text.trim();
    final String gender = selectedValue as String;
    final String height = _heightController.text.trim();
    final String weight = _heightController.text.trim();

    // Update the user object with the provided information
    var updatedUser = user_model.User(
      firstName: _user!.firstName,
      lastName: _user!.lastName,
      email: _user!.email,
      password: _user!.password,
      image: _user!.image,
      gender: gender,
      age: int.tryParse(age),
      height: double.tryParse(height),
      weight: double.tryParse(weight),
      completedOnboarding: true,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'gender': updatedUser.gender,
        'age': updatedUser.age,
        'diet': updatedUser.diet,
        'height': updatedUser.height,
        'weight': updatedUser.weight,
        'completed_onboarding': updatedUser.completedOnboarding,
      });

      // Navigate to the home page or any other desired page
      _navigateToHome();
    } catch (error) {
      // Handle any errors that occurred during the saving process
      debugPrint('Error saving user information: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Hey, ${_user?.firstName}! 👋',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Skip >',
                      style:
                          TextStyle(fontSize: 16, color: Colors.green.shade700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 150),
                  Text(
                    "Let's customize your profile:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            suffixText: 'y/o',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            labelText: 'Height',
                            suffixText: 'm',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      suffixText: 'kg',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Text(
                                '     Gender',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: _addDividersAfterItems(items),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value as String;
                                });
                              },
                              buttonStyleData:
                                  const ButtonStyleData(height: 40, width: 200),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                customHeights: _getCustomItemsHeights(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Text(
                                '    Diet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: _addDividersAfterItems(items2),
                              value: selectedValue2,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue2 = value as String;
                                });
                              },
                              buttonStyleData:
                                  const ButtonStyleData(height: 40, width: 140),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                customHeights: _getCustomItems2Heights(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  // ElevatedButton(
                  //   onPressed: saveUserInformation,
                  //   child: Text('Save'),
                  // ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed:
                      saveUserInformation,
                  )
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

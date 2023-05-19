import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../data/model/user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool isLoading = false;

  var _username = "";
  var _usernameError = "";
  var _email = "";
  var _emailError = "";
  var _password = "";
  var _passwordError = "";
  var showPass = true;
  var showConPass = true;

  // _onNameChanged(value) {
  //   setState(() {
  //     _name = value.toString();
  //   });
  // }
  //
  // _onEmailChanged(value) {
  //   setState(() {
  //     _email = value.toString();
  //   });
  // }
  //
  // _onPasswordChanged(value) {
  //   setState(() {
  //     _password = value.toString();
  //   });
  // }

  void _showSnackbar(String message, Color color) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

  Future checkIfEmailInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        _showSnackbar("Email in use", Colors.red);
      } else {
        // Return false because email adress is not in use

      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  _onClickTest() async {
    try {
      // Fetch sign-in methods for the email address
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailController.text);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        _showSnackbar("Email in use", Colors.red);
      } else {
        // Return false because email adress is not in use
        final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final user = userCredential.user;
        debugPrint("Registration Successful: ${user?.uid}");

        // Hash the password
        final hashedPassword = md5.convert(utf8.encode(_passwordController.text)).toString();

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'name': _usernameController.text,
          'email': _emailController.text,
          'password': hashedPassword,
          // Add other user data fields as needed
        });

        // Navigate to the next screen or perform any other actions
        _showSnackbar("Register successful", Colors.green);
      }
    } catch (e) {
      debugPrint("Registration Failed: $e");
    }
  }

  _navigateToLogin(){
    context.go("/login");
  }

  _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  _showConPass(bool visibility){
    setState(() {
      showConPass = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
            children: [
              Image.asset(
                "assets/images/loginTop.png",
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            // onChanged: (value) => {_onEmailChanged(value)},
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              errorText: _usernameError.isEmpty ? null : _usernameError,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.person),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 5.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            controller: _emailController,
                            // onChanged: (value) => {_onEmailChanged(value)},
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorText: _emailError.isEmpty ? null : _emailError,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.verified),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 5.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            obscureText: showPass,
                            controller: _passwordController,
                            // onChanged: (value) => {_onPasswordChanged(value)},
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () => _showPass(showPass),
                                icon:const Icon(Icons.remove_red_eye),
                              ),
                              errorText: _passwordError.isEmpty ? null : _passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            obscureText: showConPass,
                            controller: _passwordConfirmController,
                            // onChanged: (value) => {_onPasswordChanged(value)},
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              suffixIcon: IconButton(
                                onPressed: () => _showConPass(showConPass),
                                icon:const Icon(Icons.remove_red_eye),
                              ),
                              errorText: _passwordError.isEmpty ? null : _passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _onClickTest(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16)
                            ),
                            child: const Text("Register", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () => _navigateToLogin(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("have an account? "),
                              Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/loginBottom.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
        ),
      ),
    );
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   child: const Icon(Icons.add),
      // ),

  }
}

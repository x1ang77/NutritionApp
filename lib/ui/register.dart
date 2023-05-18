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
  var _email = "";
  var _emailError = "";
  var _password = "";
  var _passwordError = "";
  var _name = "";
  var _nameError = "";
  var showPass = true;
  var showConPass = true;

  _onNameChanged(value) {
    setState(() {
      _name = value.toString();
    });
  }

  _onEmailChanged(value) {
    setState(() {
      _email = value.toString();
    });
  }

  _onPasswordChanged(value) {
    setState(() {
      _password = value.toString();
    });
  }

  _onClickTest() async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      final user = userCredential.user;
      debugPrint("Registration Successful: ${user?.uid}");

      // Hash the password
      final hashedPassword = md5.convert(utf8.encode(_password)).toString();

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _name,
        'email': _email,
        'password': hashedPassword,
        // Add other user data fields as needed
      });

      // Navigate to the next screen or perform any other actions

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
          children: [
            Image.asset(
              "assets/images/loginTop.png",
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.person,
                //   size: 200,
                //   color: Colors.grey.shade500,
                // ),
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
                          onChanged: (value) => {_onEmailChanged(value)},
                          decoration: InputDecoration(
                            hintText: "Username",
                            errorText: _emailError.isEmpty ? null : _emailError,
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
                          onChanged: (value) => {_onEmailChanged(value)},
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
                          onChanged: (value) => {_onPasswordChanged(value)},
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
                          onChanged: (value) => {_onPasswordChanged(value)},
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
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16)
                          ),
                          child: const Text("Register",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
    );
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   child: const Icon(Icons.add),
      // ),

  }
}

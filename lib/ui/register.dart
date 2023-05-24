import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/data/model/user.dart';

import '../component/snackbar.dart';
import '../data/repository/user/user_repository_impl.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  UserRepoImpl userRepo = UserRepoImpl();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  var _usernameError = "";
  var _emailError = "";
  var _passwordError = "";
  var _passwordConfirmError = "";
  var showPass = true;
  var showConPass = true;
  bool isLoading = false;

  register() async {
    try {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _passwordConfirmController.text.trim();
      var emailExists = await userRepo.checkEmailInFirebase(email);

      setState(() {
        if (username.length < 8) {
          _usernameError = "Username needs to be at least 8 characters long";
          return;
        } else {
          _usernameError = "";
        }

        if (!EmailValidator.validate(email)) {
          _emailError = "Invalid email format";
          return;
        } else {
          _emailError = "";
        }

        if (password.length < 8) {
          _passwordError = "Password needs to be at least 8 characters long";
          return;
        } else {
          _passwordError = "";
        }

        if (passwordConfirm != password) {
          _passwordConfirmError = "Passwords must match";
          return;
        } else {
          _passwordConfirmError = "";
        }

        isLoading = true;
      });

      if (!emailExists) {
        showSnackbar(
            _scaffoldKey,
            "No account was registered with this email",
            Colors.red
        );
      } else {
        await userRepo.register(username, email, password);
        showSnackbar(_scaffoldKey, "Register successful", Colors.green);
        _navigateToHome();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(_scaffoldKey, "Failed to register", Colors.red);
    }
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

  _navigateToHome() {
    context.go("/home");
  }

  _navigateToLogin() {
    context.go("/login");
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
                    "Get Setup Here",
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
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              errorText: _usernameError.isEmpty ? null : _usernameError,
                              suffixIcon: const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.person),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 5.0),
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
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorText: _emailError.isEmpty ? null : _emailError,
                              suffixIcon: const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.email),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 5.0),
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
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              suffixIcon: IconButton(
                                onPressed: () => _showConPass(showConPass),
                                icon:const Icon(Icons.remove_red_eye),
                              ),
                              errorText: _passwordConfirmError.isEmpty ? null : _passwordConfirmError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => register(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16)
                            ),
                            child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3, color: Colors.white)
                              : const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () => _navigateToLogin(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already registered? "),
                              Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold),)
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
  }
}

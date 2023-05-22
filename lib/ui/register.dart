import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/data/model/user.dart';

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
  bool isLoading = false;

  var _username = "";
  var _usernameError = "";
  var _email = "";
  var _emailError = "";
  var _password = "";
  var _passwordError = "";
  var showPass = true;
  var showConPass = true;

  void _showSnackbar(String message, Color color) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

  _onClickTest() async {
    try {
      final _user = User(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          gender: "", age: 0, height: 0, weight: 0
      );
      await userRepo.register(_user);
      _showSnackbar("Register successful", Colors.green);
    } catch (e) {
      _showSnackbar("Register failed", Colors.red);
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

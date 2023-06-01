import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';
import '../component/custom_auth_painter.dart';
import '../component/snackbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserRepoImpl userRepo = UserRepoImpl();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _emailError = "";
  var _passwordError = "";
  var showPass = true;
  bool isLoading = false;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool isFocused = false;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_emailChanged);
  }

  void _emailChanged() async {
    String email = _emailController.text.trim();
    var result = await userRepo.checkEmailInFirebase(email);
    if (result) {
      isEmailVerified = true;
    } else {
      isEmailVerified = false;
    }
  }

  Future<void> login(context) async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      setState(() {
        if (email.isEmpty) {
          _emailError = "This field cannot be empty";
          return;
        } else {
          _emailError = "";
        }

        if (password.isEmpty) {
          _passwordError = "This field cannot be empty";
          return;
        } else {
          _passwordError = "";
        }

        isLoading = true;
      });

      if (_emailError.isEmpty && _passwordError.isEmpty) {
        await userRepo.login(email, password);
        showSnackbar(context, 'Login successful', Colors.green);
        _navigateToHome();
        isLoading = false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, e.toString(), Colors.red);
    }
  }

  void _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  void _navigateToHome() {
    context.go("/home");
  }

  void _navigateToForgotPassword() {
    context.push("/forgot");
  }

  void _navigateToRegister() {
    context.go("/register");
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                          "assets/images/foodsense_logo.png",
                        height: 150,
                      )
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    alignment: Alignment.center,
                    child: const Text(
                      "Welcome to Foodsense",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Column(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              errorText: _emailError.isEmpty ? null : _emailError,
                              prefixIcon: const Icon(Icons.email),
                              suffixIcon: isEmailVerified ? const Icon(Icons.verified) : null,
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
                            focusNode: _passwordFocusNode,
                            obscureText: showPass,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () => _showPass(showPass),
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              errorText:
                                  _passwordError.isEmpty ? null : _passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        GestureDetector(
                          onTap: _navigateToForgotPassword,
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => login(context),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3, color: Colors.white)
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => _navigateToRegister(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
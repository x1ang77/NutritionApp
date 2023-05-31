import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/core/custom_exception.dart';
import 'package:nutrition_app/data/model/user.dart';

import '../core/user_event.dart';
import 'component/snackbar.dart';
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
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  bool isFocused = false;
  bool isEmailVerified = false;

  Future<void> register(context) async {
    try {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _passwordConfirmController.text.trim();

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

      if (_usernameError.isEmpty && _emailError.isEmpty && _passwordError.isEmpty &&_passwordConfirmError.isEmpty) {
        var emailExists = await userRepo.checkEmailInFirebase(email);
        if (emailExists) {
          throw CustomException("An account was already registered to this email");
        }
        await userRepo.register(username, email, password);
        // showSnackbar(_scaffoldKey, "Register successful", Colors.green);
        showSnackbar(context, "Register successful", Colors.green);
        _navigateToHome();
        isLoading = false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // showSnackbar(_scaffoldKey, e.toString(), Colors.red);
      showSnackbar(context, e.toString(), Colors.red);
    }
  }

  _validate(String username, String email, String password, String passwordConfirm) {
    if (username.length < 8) {
      _usernameError = "Username needs to be at least 8 characters long";
      return false;
    } else {
      _usernameError = "";
    }

    if (!EmailValidator.validate(email)) {
      _emailError = "Invalid email format";
      return false;
    } else {
      _emailError = "";
    }

    if (password.length < 8) {
      _passwordError = "Password needs to be at least 8 characters long";
      return false;
    } else {
      _passwordError = "";
    }

    if (passwordConfirm != password) {
      _passwordConfirmError = "Passwords must match";
      return false;
    } else {
      _passwordConfirmError = "";
    }
    return true;
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
    // context.go("/home/${UserEvent.register.name}");
    context.go("/home");
  }

  _navigateToLogin() {
    context.go("/login");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: _focusNode1.hasFocus || _focusNode2.hasFocus ||
          _focusNode3.hasFocus || _focusNode4.hasFocus ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
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
                              focusNode: _focusNode1,
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
                              focusNode: _focusNode2,
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
                              focusNode: _focusNode3,
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
                              focusNode: _focusNode4,
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
                              onPressed: () => register(context),
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
                                Text("Sign in", style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: CustomPaint(
                //     painter: CurvePainter(),
                //     child: Container(),
                //   ),
                // ),
              ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    // First Curve
    final path1 = Path();

    const startPoint1 = Offset(0, 120);
    final endPoint1 = Offset(size.width, 20);

    final controlPoint1_1 = Offset(size.width * 0.35, size.height * 0.05);
    final controlPoint1_2 = Offset(size.width * 0.55, size.height * 0.15);

    path1.moveTo(startPoint1.dx, startPoint1.dy);
    path1.cubicTo(
      controlPoint1_1.dx,
      controlPoint1_1.dy,
      controlPoint1_2.dx,
      controlPoint1_2.dy,
      endPoint1.dx,
      endPoint1.dy,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    canvas.drawPath(path1, paint1);


    // Second Curve
    final path2 = Path();

    final startPoint2 = Offset(0, size.height * 0.80);
    final endPoint2 = Offset(size.width, size.height - 80);

    final controlPoint2_1 = Offset(size.width * 0.35, size.height * 0.75);
    final controlPoint2_2 = Offset(size.width * 0.65, size.height * 0.88);

    path2.moveTo(startPoint2.dx, startPoint2.dy);
    path2.cubicTo(
      controlPoint2_1.dx,
      controlPoint2_1.dy,
      controlPoint2_2.dx,
      controlPoint2_2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
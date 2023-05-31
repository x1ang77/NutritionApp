import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/data/repository/user/user_repository_impl.dart';

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
        // showSnackbar(_scaffoldKey, 'Login successful', Colors.green);
        showSnackbar(context, 'Login successful', Colors.green);
        _navigateToHome();
        isLoading = false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // showSnackbar(_scaffoldKey, 'Failed to login', Colors.red);
      showSnackbar(context, e.toString(), Colors.red);
    }
  }

  void _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  void _navigateToHome() {
    // context.go("/home/${UserEvent.login.name}");
    context.go("/home");
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
                        const SizedBox(
                          height: 20,
                        ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Forgot password",
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
              // Positioned(
              //   top: 0,
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

// class EmailField extends StatelessWidget {
//   const EmailField({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       focusNode: _focusNode1,
//       controller: _emailController,
//       decoration: InputDecoration(
//         labelText: "Email",
//         errorText: _emailError.isEmpty ? null : _emailError,
//         prefixIcon: const Icon(Icons.email),
//         suffixIcon: isEmailVerified ? Icon(Icons.verified) : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(width: 5.0),
//         ),
//       ),
//     ),
//   }
// }


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

    const startPoint1 = Offset(0, 40);
    final endPoint1 = Offset(size.width, 30);

    final controlPoint1_1 = Offset(size.width * 0.35, size.height * 0.05);
    final controlPoint1_2 = Offset(size.width * 0.55, size.height * 0.25);

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

    final startPoint2 = Offset(0, size.height * 0.85);
    final endPoint2 = Offset(size.width, size.height - 40);

    final controlPoint2_1 = Offset(size.width * 0.35, size.height * 0.75);
    final controlPoint2_2 = Offset(size.width * 0.45, size.height * 0.95);

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

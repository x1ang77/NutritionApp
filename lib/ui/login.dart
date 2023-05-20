import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../data/model/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  var _email = "";
  var _emailError = "";
  var _password = "";
  var _passwordError = "";
  var showPass = true;

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

  Future login() async {
    try {
      isLoading = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      isLoading = false;
      _navigateToHome();
      _showSnackbar('Login successful', Colors.green);
    } catch (e) {
      isLoading = false;
      debugPrint('Email or Password Incorrect');
      _showSnackbar('Login failed', Colors.red);
    }
  }

  _navigateToHome() {
    context.go("/home");
  }

  _navigateToRegister() {
    context.go("/register");
  }

  _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(),
                child: Container(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              // onChanged: (value) => {_onEmailChanged(value)},
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                errorText: _emailError.isEmpty ? null : _emailError,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.verified),
                                ),
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
                              obscureText: showPass,
                              controller: _passwordController,
                              // onChanged: (value) => {_onPasswordChanged(value)},
                              decoration: InputDecoration(
                                hintText: "Password",
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
                            child: const Text("Forgot your password"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => login(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 16)),
                              child: isLoading
                              ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    strokeWidth: 3, color: Colors.white),
                              )
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: CurvePainter(),
                  child: Container(),
                ),
              ),
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

    final startPoint2 = Offset(0, size.height * 0.88);
    final endPoint2 = Offset(size.width, size.height - 20);

    final controlPoint2_1 = Offset(size.width * 0.35, size.height * 0.95);
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

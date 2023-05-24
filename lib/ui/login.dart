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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  UserRepoImpl userRepo = UserRepoImpl();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _emailError = "";
  var _passwordError = "";
  var showPass = true;
  bool isLoading = false;

  login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      var emailExists = await userRepo.checkEmailInFirebase(email);

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

      if (!emailExists) {
        showSnackbar(
            _scaffoldKey,
            "No account was registered with this email",
            Colors.red
        );
        isLoading = false;
      } else {
        _emailError = "";
        await userRepo.login(email, password);
        showSnackbar(_scaffoldKey, 'Login successful', Colors.green);
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

  _navigateToHome() {
    context.go("/home");
  }

  _navigateToRegister() {
    context.go("/register");
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                errorText: _emailError.isEmpty ? null : _emailError,
                                prefixIcon: const Icon(Icons.email),
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
                              onPressed: () => login(),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../data/model/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _email = "";
  var _emailError = "";
  var _password = "";
  var _passwordError = "";
  var _name = "";
  var _nameError = "";

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

  _onClickTest() {
    setState(() {
      if (_email.isEmpty) {
        _emailError = "Can't be empty";
        return;
      } else {
        _emailError = "";
      }
      if (_password.isEmpty) {
        _passwordError = "Can't be empty";
        return;
      } else {
        _passwordError = "";
      }

      // if (_name.isEmpty) {
      //   _nameError = "Can't be empty";
      //   return;
      // } else {
      //   _nameError = "";
      // }

      debugPrint("$_email $_password");
    });

    debugPrint("$_email $_password");

    // AuthService.authenticate(
    //     _email,
    //     _password,
    //         (status) =>
    //     {
    //       if (status)
    //         {context.go("/home")}
    //       else
    //         {debugPrint("Wrong Credentials")}
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   "assets/images/loginTop.png",
          // ),
          CustomPaint(
            painter: CurvePainter(),
            child: Container(),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                        obscureText: true,
                        onChanged: (value) => {_onPasswordChanged(value)},
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {},
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
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onClickTest(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text(
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
                      onTap: () {},
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    // First Curve
    final path1 = Path();

    final startPoint1 = Offset(0, 120);
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

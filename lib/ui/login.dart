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
                        obscureText: true,
                        onChanged: (value) => {_onPasswordChanged(value)},
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {},
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
                    GestureDetector(
                      onTap: () {},
                      child: const Text("Forgot your password"),
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
                        child: const Text("Login",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ],
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

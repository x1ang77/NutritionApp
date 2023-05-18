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
      appBar: AppBar(
        title: const Text("Login"),
        // centerTitle: false,
        // backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () => debugPrint("Hello scaffold"),
              icon: Icon(Icons.mail)),
          IconButton(
              onPressed: () => debugPrint("Hello scaffold sms"),
              icon: Icon(Icons.sms)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.person,
          //   size: 200,
          //   color: Colors.grey.shade500,
          // ),
          Text(
            "Login",
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
          ),
          Text(
            "You entered $_email",
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
          ),

          Container(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) => {_onEmailChanged(value)},
              decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _emailError.isEmpty ? null : _emailError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              obscureText: true,
              onChanged: (value) => {_onPasswordChanged(value)},
              decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _passwordError.isEmpty ? null : _passwordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _onClickTest(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(20.0, 20.0),
                ),
                child: const Text("Login"),
              ),
            ],
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

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/core/custom_exception.dart';
import '../component/custom_auth_painter.dart';
import '../component/snackbar.dart';
import '../../data/repository/user/user_repository_impl.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  UserRepoImpl userRepo = UserRepoImpl();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  var _firstNameError = "";
  var _lastNameError = "";
  var _emailError = "";
  var _passwordError = "";
  var _passwordConfirmError = "";
  var showPass = true;
  var showConPass = true;
  bool isLoading = false;
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();
  bool isFocused = false;
  bool isEmailVerified = false;

  Future<void> register(context) async {
    try {
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _passwordConfirmController.text.trim();

      setState(() {
        if (firstName.isEmpty) {
          _firstNameError = "This field cannot be empty";
          return;
        } else {
          _firstNameError = "";
        }

        if (lastName.isEmpty) {
          _lastNameError = "This field cannot be empty";
          return;
        } else {
          _lastNameError = "";
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

      if (_firstNameError.isEmpty && _lastNameError.isEmpty && _emailError.isEmpty && _passwordError.isEmpty &&_passwordConfirmError.isEmpty) {
        var emailExists = await userRepo.checkEmailInFirebase(email);
        if (emailExists) {
          throw CustomException("An account was already registered to this email");
        }
        await userRepo.register(firstName, lastName, email, password);
        showSnackbar(context, "Register successful", Colors.green);
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

  void _showConPass(bool visibility){
    setState(() {
      showConPass = !visibility;
    });
  }

  void _navigateToHome() {
    context.go("/home");
  }

  void _navigateToLogin() {
    context.go("/login");
  }

  @override
  void dispose() {
    super.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: _firstNameFocusNode.hasFocus || _lastNameFocusNode.hasFocus || _emailFocusNode.hasFocus ||
          _passwordFocusNode.hasFocus || _passwordConfirmFocusNode.hasFocus ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
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
                        "Get set up to use Foodsense",
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
                              focusNode: _firstNameFocusNode,
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: "First Name",
                                errorText: _firstNameError.isEmpty ? null : _firstNameError,
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
                              focusNode: _lastNameFocusNode,
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                hintText: "Last Name",
                                errorText: _lastNameError.isEmpty ? null : _lastNameError,
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
                              focusNode: _emailFocusNode,
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
                              focusNode: _passwordFocusNode,
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
                              focusNode: _passwordConfirmFocusNode,
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
                                    color: Colors.white,
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
              ],
          ),
        ),
      ),
    );
  }
}
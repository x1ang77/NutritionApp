import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/ui/component/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        // showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
        showSnackbar(context, "Password reset email sent.", Colors.yellow.shade700);
        context.pop();
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.message.toString(), Colors.red);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Receive an email to \nreset your password.",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? "Enter a valid email"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.email_outlined),
                label: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  resetPassword();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

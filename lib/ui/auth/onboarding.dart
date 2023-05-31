import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nutrition_app/ui/auth/image_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);
  // final Map<String, dynamic> object;

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  String _status = 'Waiting...';
  String? username;
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    // username = widget.object["username"];
    // email = widget.object["email"];
    // password = widget.object["password"];
    // debugPrint("what's in the box? ${widget.object["username"]}, ${widget.object["email"]}, ${widget.object["password"]}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        // 2. Pass that key to the `IntroductionScreen` `key` param
        key: _introKey,
        rawPages: [
          ImagePage()
          // PageViewModel(
          //     title: 'Page One',
          //     bodyWidget: Column(
          //       children: [
          //         Text(_status),
          //         ElevatedButton(
          //             onPressed: () {
          //               setState(() => _status = 'Going to the next page...');
          //
          //               // 3. Use the `currentState` member to access functions defined in `IntroductionScreenState`
          //               Future.delayed(const Duration(seconds: 3),
          //                       () => _introKey.currentState?.next());
          //             },
          //             child: const Text('Start'))
          //       ],
          //     )),
          // PageViewModel(
          //     title: 'Page Two', bodyWidget: const Text('That\'s all folks'))
        ],
        showNextButton: true,
        showSkipButton: true,
        showDoneButton: true,

        skip: Text("Skip"),
        next: Text("Next"),
        // done: const Text("Done"),

        onSkip: () {

        },

        // onDone: () {
        //   // on button pressed
        // },
      )
    );
  }
}

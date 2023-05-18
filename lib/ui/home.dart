import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or any other screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    } catch (e) {
      // Handle logout error
      print('Logout Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camp"),
      ),
      body: Column(
        children: [
          Container(
              alignment: AlignmentDirectional.centerStart,
              child: Image.asset("assets/images/image2.jpeg")
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0), // add padding of 8 pixels at the bottom
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Oeschinen Lake Campground",
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kandersteg, Switzerland",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column( children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.red),
                          Text(" 41")
                        ],
                      ),
                    ],
                    )
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Column( children: [
                      Icon(Icons.phone, color: Colors.blueAccent),
                      Text("CALL", style: TextStyle(color: Colors.blueAccent),)
                    ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Column( children: [
                      Icon(Icons.send, color: Colors.blueAccent),
                      Text("SEND", style: TextStyle(color: Colors.blueAccent),)
                    ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Column( children: [
                      Icon(Icons.share, color: Colors.blueAccent),
                      Text("SHARE", style: TextStyle(color: Colors.blueAccent),)
                    ],
                    )
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () => _logout(), child: const Text('Logout'))
        ],
      ),
    );
  }
}

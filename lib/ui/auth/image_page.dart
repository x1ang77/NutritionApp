import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../component/custom_auth_painter.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  XFile? image;
  File? imageFile;

  void _skipToNextPage() {
    context.push("/onboarding");
  }
  
  void _navigateToNextPage() {
    context.pushNamed("image", extra: {"imageFile" : image});
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);

      setState(() {
        this.image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    alignment: Alignment.center,
                    child: const Text(
                      "Pick your profile image",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 115,
                      child: CircleAvatar(
                          radius: 110,
                          backgroundImage: image != null ? Image.file(imageFile!).image : Image.asset("assets/images/empty_profile_image.png").image,
                      ),
                    ),
                  ),
                  
                  ElevatedButton(
                      onPressed: () => _pickImage(),
                      child: Text("Pick an Image")
                  ),
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _skipToNextPage();
                        },
                        child: const Text('Skip'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          _navigateToNextPage();
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  XFile? image;
  File? imageFile;

  void _skipToNextPage() {
    context.pushNamed("image", extra: {"imageFile" : null});
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
      appBar: AppBar(
        title: const Text("Profile Image"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                alignment: Alignment.center,
                child: const Text(
                  "Set your profile image or later",
                  textAlign: TextAlign.center,
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

              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: () => _pickImage(),
                    child: const Text(
                      "Pick an Image",
                      style: TextStyle(fontSize: 20),
                    )
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {_skipToNextPage();},
                    child: const Text('Skip', style: TextStyle(fontSize: 20),),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _navigateToNextPage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.navigate_next,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
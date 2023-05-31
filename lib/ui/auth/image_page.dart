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
  File? image;
  
  void _navigateToNextPage() {
    // context.pushNamed("key", )
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);

      setState(() {
        this.image = imageFile;
        debugPrint(this.image.toString());
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
                          backgroundImage: image != null ? Image.file(image!).image : Image.asset("assets/images/empty_profile_image.png").image,
                          // backgroundImage: image != null
                          //     ? FileImage(image!)
                          //     : AssetImage("/assets/images/nuts.jpg")
                      ),
                    ),
                  ),
                  
                  ElevatedButton(
                      onPressed: () => _pickImage(),
                      child: Text("Pick an Image")
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

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint1 = Paint()
//       ..color = const Color(0xFF6AC57E) // Color for the first curve
//       ..style = PaintingStyle.fill;
//
//     final paint2 = Paint()
//       ..color = const Color(0xFF6AC57E) // Color for the first curve
//       ..style = PaintingStyle.fill;
//
//     // First Curve
//     final path1 = Path();
//
//     const startPoint1 = Offset(0, 120);
//     final endPoint1 = Offset(size.width, 20);
//
//     final controlPoint1_1 = Offset(size.width * 0.35, size.height * 0.05);
//     final controlPoint1_2 = Offset(size.width * 0.55, size.height * 0.15);
//
//     path1.moveTo(startPoint1.dx, startPoint1.dy);
//     path1.cubicTo(
//       controlPoint1_1.dx,
//       controlPoint1_1.dy,
//       controlPoint1_2.dx,
//       controlPoint1_2.dy,
//       endPoint1.dx,
//       endPoint1.dy,
//     );
//     path1.lineTo(size.width, 0);
//     path1.lineTo(0, 0);
//     path1.close();
//
//     canvas.drawPath(path1, paint1);
//
//
//     // Second Curve
//     final path2 = Path();
//
//     final startPoint2 = Offset(0, size.height * 0.80);
//     final endPoint2 = Offset(size.width, size.height - 80);
//
//     final controlPoint2_1 = Offset(size.width * 0.35, size.height * 0.75);
//     final controlPoint2_2 = Offset(size.width * 0.65, size.height * 0.88);
//
//     path2.moveTo(startPoint2.dx, startPoint2.dy);
//     path2.cubicTo(
//       controlPoint2_1.dx,
//       controlPoint2_1.dy,
//       controlPoint2_2.dx,
//       controlPoint2_2.dy,
//       endPoint2.dx,
//       endPoint2.dy,
//     );
//     path2.lineTo(size.width, size.height);
//     path2.lineTo(0, size.height);
//     path2.close();
//
//     canvas.drawPath(path2, paint2);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
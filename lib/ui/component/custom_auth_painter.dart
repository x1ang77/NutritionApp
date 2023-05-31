import 'package:flutter/cupertino.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF6AC57E) // Color for the first curve
      ..style = PaintingStyle.fill;

    // First Curve
    final path1 = Path();

    const startPoint1 = Offset(0, 40);
    final endPoint1 = Offset(size.width, 30);

    final controlPoint1_1 = Offset(size.width * 0.35, size.height * 0.05);
    final controlPoint1_2 = Offset(size.width * 0.55, size.height * 0.25);

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

    final startPoint2 = Offset(0, size.height * 0.85);
    final endPoint2 = Offset(size.width, size.height - 40);

    final controlPoint2_1 = Offset(size.width * 0.35, size.height * 0.75);
    final controlPoint2_2 = Offset(size.width * 0.45, size.height * 0.95);

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
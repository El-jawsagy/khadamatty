import 'package:flutter/material.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class BackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = CustomColors.white;
    canvas.drawPaint(paint);
    Path path1 = Path();
    path1.lineTo(0, 0);
    path1.lineTo(0, size.height*0.85 );
    path1.quadraticBezierTo(
        size.width * .6, size.height * .92, size.width, size.height * 0.6);
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    canvas.drawShadow(path1, Colors.black, 3.0, true);
    paint.color = CustomColors.primary;
    path1.close();
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class BackGroundEn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = CustomColors.white;
    canvas.drawPaint(paint);
    Path path1 = Path();
    path1.lineTo(size.width, 0);
    path1.lineTo(size.width, size.height*0.85 );
    path1.quadraticBezierTo(
        size.width * .6, size.height * .92, 0, size.height * 0.6);
    path1.lineTo(0, 0);
    path1.lineTo(size.width, 0);
    canvas.drawShadow(path1, Colors.black, 3.0, true);
    paint.color = CustomColors.primary;
    path1.close();
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

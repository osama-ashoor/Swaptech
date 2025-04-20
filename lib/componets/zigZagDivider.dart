import 'package:flutter/material.dart';

class ZigZagDivider extends StatelessWidget {
  final double height;
  final Color color;

  const ZigZagDivider({super.key, this.height = 20, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: ZigZagPainter(color: color),
        size: Size(double.infinity, height),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  final Color color;
  ZigZagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    double stepWidth = 10; // عرض كل سن متعرج
    double stepHeight = size.height / 2; // ارتفاع كل سن متعرج
    bool isUp = true;

    path.moveTo(0, stepHeight);
    for (double i = 0; i < size.width; i += stepWidth) {
      if (isUp) {
        path.lineTo(i + stepWidth / 2, 0);
      } else {
        path.lineTo(i + stepWidth / 2, size.height);
      }
      isUp = !isUp;
    }
    path.lineTo(size.width, stepHeight);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

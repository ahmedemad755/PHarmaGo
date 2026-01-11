import 'package:flutter/material.dart';

class RxSymbolPainter extends CustomPainter {
  final Color color;
  final double opacity;

  RxSymbolPainter({
    this.color = Colors.white,
    this.opacity = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw R
    final rPath = Path();
    rPath.moveTo(centerX - 40, centerY - 40);
    rPath.lineTo(centerX - 40, centerY + 40);
    rPath.lineTo(centerX - 10, centerY + 40);
    rPath.quadraticBezierTo(
      centerX + 10,
      centerY + 40,
      centerX + 10,
      centerY,
    );
    rPath.lineTo(centerX - 10, centerY);
    rPath.moveTo(centerX + 10, centerY);
    rPath.lineTo(centerX + 30, centerY + 40);
    canvas.drawPath(rPath, paint);

    // Draw x (simple cross)
    canvas.drawLine(
      Offset(centerX + 50, centerY - 20),
      Offset(centerX + 80, centerY + 20),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + 80, centerY - 20),
      Offset(centerX + 50, centerY + 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(RxSymbolPainter oldDelegate) => false;
}

class RxSymbol extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const RxSymbol({
    super.key,
    this.size = 150,
    this.color = Colors.white,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RxSymbolPainter(
        color: color,
        opacity: opacity,
      ),
    );
  }
}

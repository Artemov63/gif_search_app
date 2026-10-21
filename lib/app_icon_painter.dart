import 'package:flutter/material.dart';

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFF1F2230);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final searchPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width * 0.43, size.height * 0.43),
      size.width * 0.23,
      searchPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.59, size.height * 0.59),
      Offset(size.width * 0.78, size.height * 0.78),
      searchPaint,
    );
    final sparklePaint = Paint()
      ..color = const Color(0xFFB28AFB)
      ..style = PaintingStyle.fill;

    final sparklePath = Path()
      ..moveTo(size.width * 0.43, size.height * 0.32)
      ..lineTo(size.width * 0.46, size.height * 0.40)
      ..lineTo(size.width * 0.54, size.height * 0.43)
      ..lineTo(size.width * 0.46, size.height * 0.46)
      ..lineTo(size.width * 0.43, size.height * 0.54)
      ..lineTo(size.width * 0.40, size.height * 0.46)
      ..lineTo(size.width * 0.32, size.height * 0.43)
      ..lineTo(size.width * 0.40, size.height * 0.40)
      ..close();

    canvas.drawPath(sparklePath, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AppIconPreviewScreen extends StatelessWidget {
  const AppIconPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11131A),
      appBar: AppBar(title: const Text('App Icon Preview')),
      body: Center(
        child: CustomPaint(
          size: const Size(220, 220),
          painter: AppIconPainter(),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';

class AuroraPainter extends CustomPainter {
  final double t;

  AuroraPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AppColors.neonBlue,
      AppColors.neonPurple,
      AppColors.neonGreen
    ];
    for (var i = 0; i < 3; i++) {
      final offset = sin(t * 2 * pi + i * 2.1) * 20;
      final paint = Paint()
        ..color = colors[i].withOpacity(0.06)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(0, -60 + i * 20 + offset)
        ..quadraticBezierTo(
            size.width * 0.5, -20 + i * 15 - offset,
            size.width, -40 + i * 18 + offset)
        ..lineTo(size.width, 0)..lineTo(0, 0)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(AuroraPainter old) => old.t != old.t;
}
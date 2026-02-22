import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';

class ParticlePainter extends CustomPainter {
  final double t;
  final bool isDark;

  static final _rng = Random(42);
  static final _particles = List.generate(40, (i) => [
    _rng.nextDouble(), // x
    _rng.nextDouble(), // y start
    _rng.nextDouble() * 0.8 + 0.2, // speed
    _rng.nextDouble(), // phase
    _rng.nextInt(2).toDouble(), // color variant
  ]);

  ParticlePainter(this.t, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = p[0] * size.width;
      final y = ((p[1] + t * p[2] + p[3]) % 1.0) * size.height;
      final color = p[4] == 0 ? AppColors.neonBlue : AppColors.neonPurple;
      canvas.drawCircle(
        Offset(x, y),
        isDark ? 1.5 : 1.0,
        Paint()..color = color.withOpacity(isDark ? 0.35 : 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.t != t;
}
import 'package:flutter/cupertino.dart';
import 'package:meteo/animations/particle_painter.dart';

class ParticleField extends StatelessWidget {
  final AnimationController ctrl;
  final bool isDark;
  const ParticleField({super.key, required this.ctrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) => CustomPaint(
        size: MediaQuery.of(context).size,
        painter: ParticlePainter(ctrl.value, isDark),
      ),
    );
  }
}




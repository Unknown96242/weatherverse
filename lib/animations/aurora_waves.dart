import 'package:flutter/cupertino.dart';

import 'aurora_painter.dart';

class AuroraWaves extends StatelessWidget {
  final AnimationController ctrl;
  const AuroraWaves({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) => CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 220),
        painter: AuroraPainter(ctrl.value),
      ),
    );
  }
}


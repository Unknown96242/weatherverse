import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../utils/utils_function.dart';

Widget navigationButton(String label, Widget destination, {Animation<double>? animation , Color mainColor = AppColors.neonBlue, Color secondColor = AppColors.neonPurple}) {

  final anim = animation ?? AlwaysStoppedAnimation(1.0);

  return AnimatedBuilder(
    animation: anim,
    builder: (context, _) {
      return GestureDetector(
        onTap: () => UtilsFunction.navigation(context, destination),
        child: Container(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                mainColor.withOpacity( 0.12),
                secondColor.withOpacity( 0.12 ),
              ],
            ),
            border: Border.all(
              color: mainColor.withOpacity(0.6 + 0.4 * anim.value),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(
                  ( 0.3 ) * anim.value,
                ),
                blurRadius: 25,
                spreadRadius:  2 ,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.orbitron(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: mainColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward, color: mainColor, size: 18),
            ],
          ),
        ),
      );
    },
  );
}
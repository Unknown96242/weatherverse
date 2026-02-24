import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/components/navigation_button.dart';
import 'package:meteo/model/city_weather.dart';
import 'package:meteo/screens/home_screen.dart';
import 'package:meteo/screens/loader_screen.dart';
import 'package:meteo/theme/app_colors.dart';
import 'package:meteo/theme/theme_provider.dart';
import 'package:meteo/utils/images_constants.dart';
import 'package:meteo/utils/utils_function.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons/weather_icons.dart';

class VilleScreen extends StatefulWidget {
  const VilleScreen({super.key});

  @override
  State<VilleScreen> createState() => _VilleScreenState();
}

class _VilleScreenState extends State<VilleScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowCtrl;

  late Animation<double> _glowAnim;
  // ─────────────────────────────────────────────
  // COULEURS SELON LE THÈME
  // ─────────────────────────────────────────────

  bool get _isDark => context.read<ThemeProvider>().isDark;

  Color get _accent => _isDark ? AppColors.neonBlue : AppColors.lightBlue;
  Color get _accentGreen =>
      _isDark ? AppColors.neonGreen : AppColors.lightGreen;
  Color get _accentPurple =>
      _isDark ? AppColors.neonPurple : AppColors.lightPurple;
  Color get _textMain => _isDark ? Colors.white : AppColors.textOnLight;
  Color get _textSub =>
      _isDark ? Colors.white.withOpacity(0.5) : AppColors.subTextOnLight;
  Color get _cardBg =>
      _isDark ? Colors.white.withOpacity(0.07) : Colors.white.withOpacity(0.65);
  Color get _cardBorder => _isDark
      ? Colors.white.withOpacity(0.13)
      : AppColors.lightPurple.withOpacity(0.25);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _isDark
                  ? ImagesConstants.bgHomeDark
                  : ImagesConstants.bgHomeLight,
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
          child: Container(
            constraints:BoxConstraints( minHeight:  MediaQuery.of(context).size.height),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 17,
                      vertical: 17
                    ),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLogo(),
                    _buildRobotSection(),
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: WeatherStorage.data.length,
                      itemBuilder: (context, index) {
                        CityWeather c = WeatherStorage.data[index];
                        return Column(
                          children: [cityShow(context,c)],
                        );
                      },
                    ),
                    navigationButton(
                      "RECOMMENCER L'EXPERIENCE",
                      LoaderScreen(),
                      icon: Icons.restart_alt,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )],
      ),
    );
  }

  Widget cityShow(BuildContext context, CityWeather c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),

              //Dégradé sombre translucide
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E2A47).withOpacity(0.30),
                  Color(0xFF111827).withOpacity(0.20),
                ],
              ),

              // Fine light border
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(c.iconUrl,width: 50,height: 50,),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.condition,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${c.temperature}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "↑${c.tempMax}° ↓${c.tempMin}°",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logo de l'application
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) {
        return Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_accent, _accentPurple],
                ).createShader(bounds),
                child: Text(
                  textAlign: TextAlign.center,
                  'WEATHERVERSE',
                  style: GoogleFonts.orbitron(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: _accent.withOpacity(
                          _glowAnim.value * (_isDark ? 1.0 : 0.4),
                        ),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'MÉTÉO DU FUTUR',
                style: GoogleFonts.rajdhani(
                  fontSize: 11,
                  color: _textSub,
                  letterSpacing: 6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Robot + bulle de dialogue
  Widget _buildRobotSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 90,
          height: 108,
          child: Image.asset(
            ImagesConstants.robot,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: _cardBorder),
              boxShadow: [
                BoxShadow(color: _accent.withOpacity(0.08), blurRadius: 15),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BLOBI',
                      style: GoogleFonts.orbitron(
                        fontSize: 8,
                        color: _accentGreen,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Bonjour !',
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prêt pour la météo? ',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Je surveille 5 villes pour toi en temps réel !',
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _textSub,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

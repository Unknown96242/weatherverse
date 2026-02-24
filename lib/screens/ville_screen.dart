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
      body: SingleChildScrollView(
        child: Container(
          constraints:BoxConstraints( minHeight:  MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _isDark
                  ? AssetImage(ImagesConstants.bgHomeDark)
                  : AssetImage(ImagesConstants.bgHomeLight),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 17,
                  ),
              child: Column(
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
                        children: [cityShow(c), SizedBox(height: 15)],
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
      ),
    );
  }

  Widget cityShow(CityWeather c) {
    return GestureDetector(
      onTap: () => {UtilsFunction.navigation(context, HomeScreen())},
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.blue.withOpacity(0.6),
          //     Colors.purple.withOpacity(0.6),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          // effet translucide
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.glassDark, // contour léger
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  weatherIcon(c.temps),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.city, style: TextStyle(color: Colors.white)),
                      Text(
                        c.condition,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${c.temperature}°C",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "↑${c.tempMax}°C ↓${c.tempMin}°C",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
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

  Widget weatherIcon(String main) {
    double taille = 30;
    switch (main) {
      case "Thunderstorm":
        return Icon(WeatherIcons.cloudy, color: Colors.yellow,size: taille,);
      case "Drizzle":
        return Icon(WeatherIcons.hail, color: Colors.blue,size: taille);
      case "Rain":
        return Icon(
          WeatherIcons.rain_wind,
          color: Colors.blueAccent,
          size: taille
        );
     case "Mist":
      case "Fog":
      case "Haze":
        return Icon(WeatherIcons.fog, color: Colors.grey,size: taille);
      case "Smoke":
      case "Dust":
      case "Sand":
      case "Ash":
        return Icon(FontAwesomeIcons.wind, color: Colors.brown,size: taille);
      case "Clear":
        return Icon(WeatherIcons.day_sunny, color: Colors.orange,size: taille);
      case "Clouds":
        return Icon(WeatherIcons.cloudy, color: Colors.grey,size: taille);
      case "Tornado":
      case "Squall":
        return Icon(FontAwesomeIcons.wind, color: Colors.black,size: taille);
      default:
        return Icon(FontAwesomeIcons.question, color: Colors.white,size: taille);
    }
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

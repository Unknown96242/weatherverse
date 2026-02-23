import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/city_weather.dart';
import '../service/weather_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import '../components/navigation_button.dart';
import '../screens/home_screen.dart';
import '../utils/images_constants.dart';

const _robotMessages = [
  'Nous téléchargeons les données… 📡',
  'C\'est presque fini… ⚙️',
  'Plus que quelques secondes… ⏳',
  'Je contacte les serveurs météo… 🌐',
  'Analyse des données en cours… 🔬',
];

// Stockage global : accessible depuis HomeScreen avec WeatherStorage.data
class WeatherStorage {
  static List<CityWeather> data = [];
}

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {

  // ─────────────────────────────────────────────
  // DONNÉES
  // ─────────────────────────────────────────────

  final _weatherService = WeatherService();
  final List<CityWeather> _loadedCities = [];
  static const int _totalCities = 5;

  // _progress va de 0.0 à 1.0 (ex: 2 villes / 5 = 0.4)
  double _progress = 0.0;

  String? _errorMessage;
  int _currentMessageIndex = 0;
  bool _isDone = false;

  Timer? _messageTimer;

  // ─────────────────────────────────────────────
  // COULEURS SELON LE THÈME
  // ─────────────────────────────────────────────

  bool get _isDark => context.read<ThemeProvider>().isDark;

  Color get _accent       => _isDark ? AppColors.neonBlue   : AppColors.lightBlue;
  Color get _accentGreen  => _isDark ? AppColors.neonGreen  : AppColors.lightGreen;
  Color get _accentPurple => _isDark ? AppColors.neonPurple : AppColors.lightPurple;
  Color get _textMain     => _isDark ? Colors.white         : AppColors.textOnLight;
  Color get _textSub      => _isDark
      ? Colors.white.withOpacity(0.5)
      : AppColors.subTextOnLight;
  Color get _cardBg => _isDark
      ? Colors.white.withOpacity(0.07)
      : Colors.white.withOpacity(0.65);
  Color get _cardBorder => _isDark
      ? Colors.white.withOpacity(0.13)
      : AppColors.lightPurple.withOpacity(0.25);

  // ─────────────────────────────────────────────
  // INITIALISATION
  // ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    setState(() {
      _loadedCities.clear();
      _progress            = 0.0;
      _errorMessage        = null;
      _isDone              = false;
      _currentMessageIndex = 0;
    });
    WeatherStorage.data = [];

    // Change le message du robot toutes les 2.5 secondes
    _messageTimer?.cancel();
    _messageTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (mounted && !_isDone) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _robotMessages.length;
        });
      }
    });

    // Charge les villes une par une
    _weatherService.meteoVilleSync(
      onCityLoaded: (city, index) {
        if (!mounted) return;
        setState(() {
          _loadedCities.add(city);
          // Chaque ville = +20% (1/5)
          _progress = _loadedCities.length / _totalCities;
        });
      },
    ).then((allCities) {
      if (!mounted) return;
      WeatherStorage.data = allCities;
      setState(() {
        _progress = 1.0;
        _isDone   = true;
      });
      _messageTimer?.cancel();
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isDone       = true;
      });
      _messageTimer?.cancel();
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDark
                ? const [AppColors.darkNavy, AppColors.darkPurple]
                : const [AppColors.lightSky, AppColors.lightLavender],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 48),
                _buildGauge(),
                const SizedBox(height: 32),
                _buildCityBadges(),
                const Spacer(),
                _buildRobotSection(),
                const SizedBox(height: 20),
                if (_isDone && _errorMessage == null) ...[
                  navigationButton(
                    "Continuer",
                    HomeScreen(),
                    mainColor: _accent,
                    secondColor: _accentPurple,
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _isDone ? 'CHARGEMENT TERMINÉ' : 'CHARGEMENT EN COURS',
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textSub,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isDone
                  ? '${_loadedCities.length} villes chargées avec succès' 
                  : _loadedCities.isEmpty
                  ? 'Connexion aux serveurs météo…'
                  : 'Ville ${_loadedCities.length} / $_totalCities chargée',
              style: GoogleFonts.rajdhani(fontSize: 14, color: _textSub),
            ),
            _isDone ? Container(
                margin: EdgeInsets.only(left: 4),
                child: Icon(Icons.check, color: _accentGreen))
                :
                Text('')
            ,
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // JAUGE — version simple avec CircularProgressIndicator
  //
  // Flutter gère tout : le dessin, l'animation, la progression.
  // On lui donne juste _progress (0.0 à 1.0) et il fait le reste.
  // ─────────────────────────────────────────────

  Widget _buildGauge() {
    final percent = (_progress * 100).toInt();

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Cercle de fond (toujours visible, couleur atténuée)
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1.0, // toujours plein = c'est juste le fond gris
              strokeWidth: 12,
              color: _accent.withOpacity(0.1),
            ),
          ),

          // Arc de progression (augmente au fur et à mesure)
          // AnimatedContainer gère la transition fluide de _progress
          SizedBox(
            width: 200,
            height: 200,
            child: TweenAnimationBuilder<double>(
              // TweenAnimationBuilder anime automatiquement entre
              // l'ancienne valeur et la nouvelle quand _progress change
              tween: Tween<double>(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  color: _accent,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ),

          // Texte au centre : pourcentage
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              !_isDone? Image.asset(
                ImagesConstants.weatherLoad,
                )
                  :
              Text(''),
              // const SizedBox(height: 4),
              Text(
                '$percent%',
                style: GoogleFonts.orbitron(
                  fontSize: _isDone? 48 : 20,
                  fontWeight: FontWeight.w900,
                  color: _accent,
                ),
              ),
              if (_isDone) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _startLoading,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _accentGreen.withOpacity(0.7)),
                      color: _accentGreen.withOpacity(0.1),
                    ),
                    child: Text(
                      '🔁 RECOMMENCER',
                      style: GoogleFonts.orbitron(
                        fontSize: 9,
                        color: _accentGreen,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BADGES DES VILLES
  // ─────────────────────────────────────────────

  Widget _buildCityBadges() {
    if (_errorMessage != null) {
      return Text(
        'Impossible de charger les villes',
        style: GoogleFonts.rajdhani(fontSize: 13, color: Colors.redAccent),
      );
    }

    if (_loadedCities.isEmpty) {
      return Text(
        'En attente des données…',
        style: GoogleFonts.rajdhani(fontSize: 13, color: _textSub),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _loadedCities.map((city) => _cityBadge(city)).toList(),
    );
  }

  Widget _cityBadge(CityWeather city) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _accent.withOpacity(0.12),
        border: Border.all(color: _accent.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: _accent.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇸🇳', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                city.city,
                style: GoogleFonts.rajdhani(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _accent,
                ),
              ),
              Text(
                '${city.temperature.toStringAsFixed(1)}°C · ${city.condition}',
                style: GoogleFonts.rajdhani(fontSize: 12, color: _textSub, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ROBOT + BULLE
  // ─────────────────────────────────────────────

  Widget _buildRobotSection() {
    final String message;
    if (_errorMessage != null) {
      message = 'Erreur de connexion, réessaie !';
    } else if (_isDone) {
      message = 'Toutes les villes sont chargées ! Tu peux continuer 🎉';
    } else {
      message = _robotMessages[_currentMessageIndex];
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            // Utilise sin() pour créer un mouvement de flottement
            // sin() oscille entre -1 et 1 naturellement
            final offset = 4 * (value % 1 < 0.5
                ? value * 2
                : 2 - value * 2) - 2;
            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
          },
          child: SizedBox(
            width: 90, height: 108,
            child: Image.asset(ImagesConstants.robot, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: _buildBulleMessage(message)),
      ],
    );
  }

  Widget _buildBulleMessage(String message) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(message),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentGreen,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'BLOBI',
                  style: GoogleFonts.orbitron(
                    fontSize: 8, color: _accentGreen, letterSpacing: 2, fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.rajdhani(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _errorMessage != null ? Colors.redAccent : _textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
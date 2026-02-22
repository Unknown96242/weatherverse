import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../animations/aurora_waves.dart';
import '../animations/particle_field.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {

  // ── Animations ──
  late final AnimationController _btnCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _glowCtrl;

  late final Animation<double> _robotAnim;
  late final Animation<double> _btnGlow;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);

    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _btnGlow   = Tween<double>(begin: 0.3, end: 1).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
    _glowAnim  = Tween<double>(begin: 0.4, end: 1).animate(
        CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    _particleCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  bool get _isDark => widget.themeMode == ThemeMode.dark;

  // ─── Gradient background ───
  Gradient get _bgGradient => _isDark
      ? const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.darkNavy, AppColors.darkPurple],
  )
      : const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.lightSky, AppColors.lightLavender],
  );

  Color get _cardBg  => _isDark ? AppColors.glassDark  : AppColors.glassLight;
  Color get _cardBorder => _isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get _textMain => _isDark ? Colors.white : AppColors.darkNavy;
  Color get _textSub  => _isDark
      ? Colors.white.withOpacity(0.55)
      : AppColors.darkNavy.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _bgGradient),
        child: Stack(
          children: [
            // ── Background particles ──
            ParticleField(ctrl: _particleCtrl, isDark: _isDark),

            // ── Aurora waves (dark only) ──
            if (_isDark) AuroraWaves(ctrl: _particleCtrl),

            // ── Main content ──
            SafeArea(
              child: Column(
                children: [
                  _buildStatusBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildLogo(),
                            const SizedBox(height: 28),
                            _buildGlobe(size),
                            const SizedBox(height: 28),
                            _buildRobotRow(),
                            const SizedBox(height: 32),
                            _buildCTAButton(),
                            const SizedBox(height: 24),
                            _buildQuickStats(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STATUS BAR
  // ─────────────────────────────────────────────
  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          GestureDetector(
            onTap: widget.onToggleTheme,
            child: AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, __) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _cardBg,
                  border: Border.all(color: _cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonBlue.withOpacity(0.2 * _glowAnim.value),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    !_isDark ? Icons.nights_stay_rounded : Icons.sunny,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  LOGO
  // ─────────────────────────────────────────────
  Widget _buildLogo() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, __) => ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.neonBlue, AppColors.neonPurple],
            ).createShader(bounds),
            child: Text(
              'WEATHERVERSE',
              style: GoogleFonts.orbitron(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: AppColors.neonBlue.withOpacity(_glowAnim.value),
                    blurRadius: 20,
                  ),
                ],
              ),
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
    );
  }

  // ─────────────────────────────────────────────
  //  GLOBE 3D
  // ─────────────────────────────────────────────
  Widget _buildGlobe(Size size) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 240,
        child: ModelViewer(
          src: 'assets/models/earth.glb',
          alt: 'Modèle 3D anime',
          autoPlay: true,
          autoRotate: true,
          autoRotateDelay: 0,
          rotationPerSecond: '30deg',
          cameraControls: true,
          shadowIntensity: 1,
          exposure: 1.0,
          // backgroundColor: const Color(0x00000000),
          ar: false,

          // Charge le JS depuis les assets locaux
          relatedJs: '',
          relatedCss: '',
        )
    );
  }

  // ─────────────────────────────────────────────
  //  ROBOT ROW
  // ─────────────────────────────────────────────
  Widget _buildRobotRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Robot
        SizedBox(
          width: 90,
          height:90 * 1.2,
          child: Image.asset(
            'assets/img/chatbot.gif',
            width: 90,
            height: 90,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 14),
        // Speech bubble
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
                BoxShadow(
                  color: AppColors.neonBlue.withOpacity(0.08),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour ! Prêt pour la météo ?',
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Je surveille 5 villes pour toi en temps réel !',
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

  // ─────────────────────────────────────────────
  //  CTA BUTTON
  // ─────────────────────────────────────────────
  Widget _buildCTAButton() {
    return AnimatedBuilder(
      animation: _btnGlow,
      builder: (_, __) => GestureDetector(
        onTap: () {
          // TODO: navigate to LoadingScreen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.darkNavy,
              content: Text(
                'Lancement en cours…',
                style: GoogleFonts.orbitron(color: AppColors.neonBlue),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppColors.neonBlue.withOpacity(0.12),
                AppColors.neonPurple.withOpacity(0.12),
              ],
            ),
            border: Border.all(
              color: AppColors.neonBlue.withOpacity(0.6 + 0.4 * _btnGlow.value),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonBlue.withOpacity(0.3 * _btnGlow.value),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shimmer sweep
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AnimatedBuilder(
                  animation: _particleCtrl,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(
                      ((_particleCtrl.value * 2 - 1) * 400) - 80,
                      0,
                    ),
                    child: Container(
                      width: 80,
                      height: 62,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.neonBlue.withOpacity(0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Label
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LANCER L\'EXPÉRIENCE',
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neonBlue,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward,
                      color: AppColors.neonBlue, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  QUICK STATS CARDS
  // ─────────────────────────────────────────────
  Widget _buildQuickStats() {
    final stats = [
      _StatData('🌍', '5', 'VILLES'),
      _StatData('⏱️', '5s', 'INTERVALLE'),
      _StatData('📡', 'LIVE', 'DONNÉES'),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: stats.indexOf(s) == 0 ? 0 : 6,
              right: stats.indexOf(s) == 2 ? 0 : 6,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPurple.withOpacity(0.07),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(s.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  s.value,
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neonBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.label,
                  style: GoogleFonts.orbitron(
                    fontSize: 9,
                    letterSpacing: 1.5,
                    color: _textSub,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}




// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class _StatData {
  final String icon;
  final String value;
  final String label;
  const _StatData(this.icon, this.value, this.label);
}

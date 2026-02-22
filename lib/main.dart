import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/screens/home_screen.dart';
import 'package:meteo/theme/app_theme.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'animations/aurora_waves.dart';
import 'animations/particle_field.dart';


void main() {
  runApp(const WeatherVerseApp());
}

class WeatherVerseApp extends StatefulWidget {
  const WeatherVerseApp({super.key});

  @override
  State<WeatherVerseApp> createState() => _WeatherVerseAppState();
}

class _WeatherVerseAppState extends State<WeatherVerseApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherVerse',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: AppTheme.dark(),
      theme: AppTheme.light(),
      home: HomeScreen(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}





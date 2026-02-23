import 'package:flutter/material.dart';
import 'package:meteo/screens/home_screen.dart';
import 'package:meteo/theme/app_theme.dart';



import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const WeatherVerseApp(),
  ),
  );
}

class WeatherVerseApp extends StatefulWidget {
  const WeatherVerseApp({super.key});

  @override
  State<WeatherVerseApp> createState() => _WeatherVerseAppState();
}

class _WeatherVerseAppState extends State<WeatherVerseApp> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'WeatherVerse',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      darkTheme: AppTheme.dark(),
      theme: AppTheme.light(),
      home: HomeScreen(),
    );
  }
}





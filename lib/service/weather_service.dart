import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../model/city_weather.dart';

class WeatherService {
  static const String _apiKey = '***REMOVED***';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static const List<String> _allCities = [
    'Dakar', 'Thiès', 'Saint-Louis', 'Ziguinchor', 'Kaolack',
    'Mbour', 'Diourbel', 'Tambacounda', 'Louga', 'Touba',
    'Kolda', 'Matam', 'Fatick', 'Sédhiou', 'Kédougou',
  ];

  // Choisit 5 villes au hasard
  List<String> _villeAleatoire() {
    final shuffled = List<String>.from(_allCities)..shuffle(Random());
    return shuffled.take(5).toList();
  }

  // ─────────────────────────────────────────────
  // Méthode principale : appels UN PAR UN (synchrone)
  // onCityLoaded un callback appelé dès qu'une ville
  // est chargée. Permet au loader de mettre à jour la
  // jauge et les badges en temps réel, sans attendre les 5.
  // ─────────────────────────────────────────────
  Future<List<CityWeather>> meteoVilleSync({
    required void Function(CityWeather city, int index) onCityLoaded,
  }) async {
    final cities = _villeAleatoire();
    final List<CityWeather> results = [];

    //Boucler sur chaque ville
    for (int i = 0; i < cities.length; i++) {
      final city = await _fetchCity(cities[i]);

      if (city != null) {
        results.add(city);
        // On prévient le loader qu'une ville est prête
        onCityLoaded(city, i);
      }

      // Pause entre chaque requête
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    return results;
  }

  Future<CityWeather?> _fetchCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city,SN&appid=$_apiKey&units=metric&lang=fr'),
      );

      if (response.statusCode == 200) {
        return CityWeather.fromJson(city, jsonDecode(response.body));
      }
    } catch (e) {
      print('Erreur pour $city : $e');
    }
    return null;
  }
}
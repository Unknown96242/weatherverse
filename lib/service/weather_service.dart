import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/city_weather.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['API_TOKEN']??'';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  // static const String _baseUrlForcast = 'https://api.openweathermap.org/data/2.5/forecast';

  static const List<String> _allCities = [
    'Dakar', 'Thiès', 'Saint-Louis', 'Ziguinchor', 'Touba',
    'Kolda', 'Matam', 'Sédhiou', 'Kédougou'];

  List<String> _villeAleatoire() {
    final shuffled = List<String>.from(_allCities)..shuffle(Random());
    return shuffled.take(5).toList();
  }

  Future<List<CityWeather>> meteoVilleSync({
    required void Function(CityWeather city, int index) onCityLoaded,
  }) async {
    final cities = _villeAleatoire();
    final List<CityWeather> results = [];

    for (int i = 0; i < cities.length; i++) {
      try {
        final city = await _fetchCity(cities[i]).timeout(
          const Duration(seconds: 20),
        );

        if (city != null) {
          results.add(city);
          onCityLoaded(city, i);
        }

      } on TimeoutException {
        throw Exception('Temps dépassé pour ${cities[i]}. Vérifie ta connexion.');
      } catch (e) {
        throw Exception('Erreur pour ${cities[i]} : $e');
      }

      await Future.delayed(const Duration(milliseconds: 1500));
    }

    return results;
  }

  Future<CityWeather?> _fetchCity(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city,SN&appid=$_apiKey&units=metric&lang=fr'),
    );

    if (response.statusCode == 200) {
      return CityWeather.fromJson(city, jsonDecode(response.body));
    }
    // Si statut != 200, on lance aussi une erreur claire
    throw Exception('Statut ${response.statusCode} pour $city');
  }


}
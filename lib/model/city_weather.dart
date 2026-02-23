class CityWeather {
  final String city;
  final double temperature;
  final String condition;

  CityWeather({
    required this.city,
    required this.temperature,
    required this.condition,
  });

  factory CityWeather.fromJson(String city, Map<String, dynamic> json) {
    return CityWeather(
      city: city,
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['description'],
    );
  }
}
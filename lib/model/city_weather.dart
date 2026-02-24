class CityWeather {
  final String city;
  final double temperature;
  final String condition;
  final double tempMax;
  final double tempMin;
  final String temps;
  final String icon;

  CityWeather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.tempMax,
    required this.tempMin,
    required this.temps,
    required this.icon,
  });

  factory CityWeather.
  fromJson(String city, Map<String, dynamic> json) {
    return CityWeather(
      city: city,
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['description'],
      tempMax: json['main']['temp_max'],
      tempMin: json['main']['temp_min'],
      temps: json['weather'][0]['main'],
      icon: json['']
    );
  }

  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
}
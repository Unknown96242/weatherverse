class CityWeather {
  final String city;
  final double temperature;
  final String condition;
  final double tempMax;
  final double tempMin;
  final String temps;
  final String icon;
  final double lat;
  final double lon;
  final double feelLike;
  final double visibility;
  final double pressure;
  final double windSpeed;
  final int humidity;
  final int sunrise;
  final int sunset;
  
  int? sunriseHour;
  int? sunriseMinute;
  int? sunsetHour;
  int? sunsetMinute;

  String fullSunriseHour="";
  String fullSunsetHour="";

  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";

  CityWeather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.tempMax,
    required this.tempMin,
    required this.temps,
    required this.icon,
    required this.lat,
    required this.lon,
    required this.feelLike,
    required this.visibility,
    required this.pressure,
    required this.windSpeed,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
  }){
   sunriseHour =  DateTime.fromMillisecondsSinceEpoch(sunrise*1000).hour;
   sunsetHour =  DateTime.fromMillisecondsSinceEpoch(sunset*1000).hour;
   sunriseMinute = DateTime.fromMillisecondsSinceEpoch(sunrise*1000).minute;
   sunsetMinute = DateTime.fromMillisecondsSinceEpoch(sunset*1000).minute;

   fullSunriseHour = "$sunriseHour:$sunriseMinute";
   fullSunsetHour = "$sunsetHour:$sunsetMinute";

  }

  factory CityWeather.
  fromJson(String city, Map<String, dynamic> json) {
    return CityWeather(
      city: city,
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['description'],
      tempMax: json['main']['temp_max'],
      tempMin: json['main']['temp_min'],
      temps: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      lat: json['coord']['lat'],
      lon: json['coord']['lon'],
      feelLike: json['main']['feels_like'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }

}
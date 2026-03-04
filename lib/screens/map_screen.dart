import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meteo/model/city_weather.dart';
import 'package:meteo/theme/app_colors.dart';
import 'package:meteo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final CityWeather cityWeather;

  const MapScreen({super.key, required this.cityWeather});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController mapController = MapController();

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        //backgroundColor: Colors.black26.withOpacity(.7),
        context: context,
        elevation: 1,
        builder: (context) => _buildBottomSheet(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeProvider>().isDark;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              backgroundColor: isDark
                  ? Colors.black.withOpacity(.5)
                  : AppColors.lightLavender,
              initialCenter: LatLng(
                widget.cityWeather.lat,
                widget.cityWeather.lon,
              ),
            ),
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isDark
                      ? Colors.black.withOpacity(.5)
                      : AppColors.lightLavender.withOpacity(.3),
                  BlendMode.srcOver,
                ),
                child: TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.weatherverse.app',
                ),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      widget.cityWeather.lat,
                      widget.cityWeather.lon,
                    ),
                    width: 140,
                    height: 140,
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildBottomSheet(),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.cityWeather.city,
                            style: TextStyle(
                              color: _textMain,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "${widget.cityWeather.temperature.toInt()}°",
                            style: TextStyle(
                              color: _textMain,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(CupertinoIcons.location_solid, size: 50,color: Colors.red,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(top: 40, left: 25, child: _btnBack()),
          Positioned(top: 40, right: 25, child: _btnMode()),
          Positioned(top: 100, right: 25, child: _btnBackPosition()),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        // physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            GridView.count(
              physics: ClampingScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                _buldCard(
                  "RESSENTI",
                  widget.cityWeather.feelLike.toInt().toString(),
                ),
                _buldCard(
                  "PRESSION",
                  widget.cityWeather.pressure.toInt().toString(),
                ),
                _buldCard(
                  "HUMIDITÉ",
                  widget.cityWeather.humidity.toInt().toString(),
                ),
                _buldCard(
                  "VENT",
                  widget.cityWeather.windSpeed.toInt().toString(),
                ),
                _buldCard("COUCHER", widget.cityWeather.fullSunsetHour),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnBack() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(CupertinoIcons.arrow_left),
        ),
      ),
    );
  }

  Widget _btnBackPosition() {
    return InkWell(
      onTap: () => mapController.moveAndRotate(
        LatLng(widget.cityWeather.lat, widget.cityWeather.lon),
        12.0,
        0.0
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(CupertinoIcons.location_north_fill, size: 18),
        ),
      ),
    );
  }

  Widget _btnMode() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, _) {
        return InkWell(
          onTap: () => context.read<ThemeProvider>().toggle(),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _cardBg,
              border: Border.all(color: _cardBorder),
              boxShadow: [
                BoxShadow(
                  color: _accent.withOpacity(0.2 * _glowAnim.value),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              _isDark ? Icons.sunny : Icons.nights_stay_rounded,
              size: 18,
              color: _isDark ? _accent : _accentPurple,
            ),
          ),
        );
      },
    );
  }

  Widget _buldCard(String cardName, String value) {
    IconData? icon;
    String? unite;

    switch (cardName) {
      case "RESSENTI":
        icon = CupertinoIcons.thermometer;
        unite = "°";
        break;
      case "VISIBILITÉ":
        icon = CupertinoIcons.eye_fill;
        unite = "km";
        break;
      case "PRESSION":
        icon = CupertinoIcons.gauge;
        unite = "hPa";
        break;
      case "HUMIDITÉ":
        icon = CupertinoIcons.drop_fill;
        unite = "%";
        break;
      case "COUCHER":
        icon = CupertinoIcons.sunset_fill;
        break;
      case "VENT":
        icon = CupertinoIcons.wind;
        unite = "m/s";
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 9,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Icon(
                      color: _textMain,
                      icon ??
                          CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                    ),
                    Text(
                      cardName,
                      style: TextStyle(fontSize: 15, color: _textMain),
                    ),
                  ],
                ),
                Text(
                  "${value}${unite ?? ""}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: _textSub,
                  ),
                ),
              ],
            ),
            if (cardName == "RESSENTI") ...[
              Text(
                "Réelle : ${widget.cityWeather.temperature.toInt()}°",
                style: TextStyle(color: _textSub, fontSize: 20),
              ),
            ],
            if (cardName == "COUCHER") ...[
              Text(
                "Lever : ${widget.cityWeather.fullSunriseHour}",
                style: TextStyle(color: _textSub, fontSize: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

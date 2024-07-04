import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/responsive.dart';
import 'package:weather_app/utils/strings_utils.dart';

class WeatherDetails extends StatelessWidget {
  final Weather weather;

  const WeatherDetails({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Initialize the responsive helper

    return Padding(
      padding: EdgeInsets.all(responsive.smallPadding),
      child: SizedBox(
        width: responsive.isTablet ? 400 : double.infinity,
        height: responsive.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Display city name with pin icon
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Image.asset(
                    "assets/pin.png",
                    width: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    weather.cityName,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: responsive.largeFontSize,
                    ),
                  ),
                  const Spacer(),
                  // Display weather icon from OpenWeatherMap
                  Image.network(
                      'https://openweathermap.org/img/w/${weather.icon}.png'),
                ]),
                // Display weather icon mapped from icon code
                SizedBox(
                  height: 160,
                  child:
                      Image.asset("assets/${mapIconToAsset(weather.icon)}.png"),
                ),
                SizedBox(height: responsive.largePadding),
                // Display temperature
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: TextStyle(
                      fontSize: responsive.largestFontSize,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold),
                ),
                // Display weather condition
                Text(
                  weather.condition,
                  style: TextStyle(
                      fontSize: responsive.smallFontSize,
                      color: AppColors.whiteColor),
                ),
                // Display humidity
                Text('Humidity: ${weather.humidity}%',
                    style: const TextStyle(color: AppColors.whiteColor)),
                // Display wind speed
                Text('Wind Speed: ${weather.windSpeed} m/s',
                    style: const TextStyle(color: AppColors.whiteColor)),
              ],
            ),
            // Refresh button to fetch updated weather data
            ElevatedButton(
              onPressed: () {
                Provider.of<WeatherProvider>(context, listen: false)
                    .fetchWeather(weather.cityName);
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

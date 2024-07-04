import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/weather_details.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/responsive.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Initialize the responsive helper
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(responsive.smallPadding),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                gradient: AppColors.linearGradientBlue,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              width: responsive.isTablet ? 400 : double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Display weather data or loading indicator or error message
                  Consumer<WeatherProvider>(
                    builder: (context, weatherProvider, child) {
                      if (weatherProvider.loading) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.whiteColor));
                      } else if (weatherProvider.errorMessage.isNotEmpty) {
                        return Text(weatherProvider.errorMessage);
                      } else if (weatherProvider.weather != null) {
                        return WeatherDetails(
                            weather: weatherProvider.weather!);
                      } else {
                        return const Text(
                            'Enter a city name to get weather information.');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

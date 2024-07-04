// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/weather_details_screen.dart';
import 'package:weather_app/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load last searched cities
    Provider.of<WeatherProvider>(context, listen: false)
        .loadLastSearchedCities();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Initialize the responsive helper

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(responsive.smallPadding),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: responsive.isTablet ? 400 : double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: responsive.largePadding),
                  // Search bar to enter city name
                  _buildSearchBar(),
                  SizedBox(height: responsive.largePadding),
                  // Button to trigger the weather search
                  _buildWeatherSearchButton(context),
                  SizedBox(height: responsive.largePadding),

                  // Display loading indicator or error message
                  _buildErrorMessage(context),

                  // List of last searched cities
                  _buildSearchedCitiesList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for the search bar
  Widget _buildSearchBar() {
    return SizedBox(
      height: 55,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Enter city name",
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
            },
          ),
        ),
      ),
    );
  }

  // Widget for the weather search button
  Widget _buildWeatherSearchButton(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        return ElevatedButton(
          onPressed: () async {
            await context
                .read<WeatherProvider>()
                .fetchWeather(_controller.text);

            // Navigate to details screen if no error message
            if (weatherProvider.errorMessage.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WeatherDetailsScreen()),
              );
            }
          },
          child: const Text('Get Weather'),
        );
      },
    );
  }

  // Widget to display error message or loading indicator
  Widget _buildErrorMessage(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.loading) {
          return const CircularProgressIndicator();
        } else {
          return Text(weatherProvider.errorMessage);
        }
      },
    );
  }

  // Widget for displaying the list of last searched cities
  Widget _buildSearchedCitiesList(BuildContext context) {
    return Expanded(
      child: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          List cities = weatherProvider.lastSearchedCities.reversed.toList();
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: cities.length,
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () async {
                  await context
                      .read<WeatherProvider>()
                      .fetchWeather(cities[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WeatherDetailsScreen()),
                  );
                },
                leading: const Icon(Icons.history),
                title: Text(cities[index]),
              );
            },
          );
        },
      ),
    );
  }
}

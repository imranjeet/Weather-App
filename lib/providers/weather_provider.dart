import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider class for managing weather data and state
class WeatherProvider with ChangeNotifier {
  List<String> _lastSearchedCities = []; // List to hold last searched cities
  Weather? _weather;
  bool _loading = false; // Indicates if data is being loaded
  String _errorMessage = ''; // Holds error messages if any
  final String _apiKey = '00d081ca5714850f38e394f688a03f90';

  // Getters for weather data, loading state, and error message
  Weather? get weather => _weather;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<String> get lastSearchedCities => _lastSearchedCities;

  // Fetch weather data for a given city name
  Future<void> fetchWeather(String city) async {
    _loading = true;
    notifyListeners();

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print("data: $data");
        }
        _weather = Weather.fromJson(data);
        _errorMessage = '';
        _saveLastSearchedCity(city); // Save the last searched city
      } else {
        _errorMessage = 'City not found';
        Fluttertoast.showToast(msg: "City not found");
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch weather data';
      Fluttertoast.showToast(msg: "Failed to fetch weather data");
    }

    _loading = false;
    notifyListeners();
  }

  // Save the last searched city to persistent storage
  Future<void> _saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_lastSearchedCities.contains(city)) {
      _lastSearchedCities
          .add(city); // Add city to the list if it's not already present
      final citiesJson =
          json.encode(_lastSearchedCities); // Convert list to JSON
      await prefs.setString(
          'lastSearchedCities', citiesJson); // Save JSON to SharedPreferences
    }
  }

  // Load the last searched cities from persistent storage
  Future<void> loadLastSearchedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = prefs.getString('lastSearchedCities');
    if (citiesJson != null) {
      _lastSearchedCities = json
          .decode(citiesJson)
          .cast<String>(); // Decode JSON to list of strings
      notifyListeners();
    }
  }
}

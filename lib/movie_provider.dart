import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieProvider with ChangeNotifier {
  final String apiUrl = "https://imdb146.p.rapidapi.com/v1";
  final String apiKey = "ba5c8f8157msha4a0be2c76a5b1p163b66jsn5f5e41f4a810";
  final String apiHost = "imdb146.p.rapidapi.com";

  List<dynamic> _movies = [];
  bool _isLoading = false;

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$apiUrl/find?q=$query"),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _movies = data['results'] ?? [];
      } else {
        _movies = [];
      }
    } catch (e) {
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

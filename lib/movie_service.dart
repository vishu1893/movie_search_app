import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _baseUrl = 'https://imdb146.p.rapidapi.com/v1/find/?query=brad';

  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=$query'),
      headers: {
        "X-RapidAPI-Key": "ba5c8f8157mshca4a0be2c76a5b1p163b66jsn5f5e414fa810",
        "X-RapidAPI-Host": "imdb146.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> movies = data['titleResults']['results'] ?? [];
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

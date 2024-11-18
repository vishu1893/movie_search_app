import 'package:flutter/material.dart';
import 'movie_service.dart';
import 'package:logger/logger.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _movies = [];
  bool _isLoading = false;
  final Logger _logger = Logger();

  // API Call method
  void _searchMovies() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await MovieService().searchMovies(_searchController.text);
      _logger.d("Fetched Movies: $movies");
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      _logger.e("Error fetching movies: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for a movie...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ListTile(
                          leading: movie['titlePosterImageModel'] != null
                              ? Image.network(
                                  movie['titlePosterImageModel']['url'],
                                  width: 50,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.movie),
                          title: Text(movie['titleNameText'] ?? "No Title"),
                          subtitle: Text(
                              movie['titleReleaseText'] ?? "No Release Year"),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

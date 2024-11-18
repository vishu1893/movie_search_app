import 'package:flutter/material.dart';
import 'movie_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movie Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MovieSearchPage(),
    );
  }
}

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({Key? key}) : super(key: key);

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _movies = [];
  bool _isLoading = false;

  void _searchMovies() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await MovieService().searchMovies(_searchController.text);
      print("Fetched Movies: $movies");
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print("Error fetching movies: $e");
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

                        final title = movie['titleNameText'] ?? "No Title";
                        final description =
                            movie['titleReleaseText'] ?? "No Description";
                        final imageUrl = movie['titlePosterImageModel']?['url'];

                        print("Movie $index: $title, $description, $imageUrl");

                        return ListTile(
                          leading: imageUrl != null
                              ? Image.network(imageUrl,
                                  width: 50, fit: BoxFit.cover)
                              : const Icon(Icons.movie),
                          title: Text(title),
                          subtitle: Text(description),
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

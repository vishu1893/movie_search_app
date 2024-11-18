import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movie_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search movies...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    movieProvider.fetchMovies(_searchController.text.trim());
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            if (movieProvider.isLoading)
              CircularProgressIndicator()
            else if (movieProvider.movies.isEmpty)
              Expanded(
                child: Center(
                  child: Text("No results found!"),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    final movie = movieProvider.movies[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: movie['image'] != null
                            ? Image.network(movie['image'],
                                width: 50, fit: BoxFit.cover)
                            : Icon(Icons.movie),
                        title: Text(movie['title'] ?? "No Title"),
                        subtitle: Text(movie['description'] ?? ""),
                      ),
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

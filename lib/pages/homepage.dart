import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
//import '../moviemodels/models.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);

    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        title: Text('Movie Search'),
        backgroundColor: Colors.black, // Optional: Match app bar color with the background
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/movie.jpg', // Path to the logo
                width: 50, // Adjust the width as needed
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search for a movie',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), // Set label text color to white for visibility
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 33, 243, 124)),
                ),
                
              ),
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), 
              onSubmitted: (query) {
                movieBloc.add(SearchMovies(query));
              },
            ),
            
          ),
          
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return ListTile(
                        leading: Image.network(movie.poster, width: 50, fit: BoxFit.cover),
                        title: Text(movie.title, style: TextStyle(color: Colors.white)), // Set title color to white
                        subtitle: Text(
                          '${movie.year} - ${movie.type}',
                          style: TextStyle(color: Colors.grey), // Set subtitle color to a lighter grey
                        ),
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.white), // Set error text color to white
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Search for a movie',
                    style: TextStyle(color: Colors.white), // Set placeholder text color to white
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

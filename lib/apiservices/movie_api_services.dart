
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../moviemodels/models.dart';

class MovieApiService {
  final String _apiKey = '8610be73';

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('http://www.omdbapi.com/?s=$query&apikey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return (data['Search'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
      } else {
        throw Exception('No movies found');
      }
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}

// test/bloc/movie_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/bloc/movie_bloc.dart';
import 'package:flutter_application_1/bloc/movie_event.dart';
import 'package:flutter_application_1/bloc/movie_state.dart';
import 'package:flutter_application_1/apiservices/movie_api_services.dart';
import 'package:flutter_application_1/moviemodels/models.dart';



// Create a Mock class for MovieApiService
class MockMovieApiService extends Mock implements MovieApiService {}

void main() {
  late MovieBloc movieBloc;
  late MockMovieApiService mockMovieApiService;

  setUp(() {
    mockMovieApiService = MockMovieApiService();
    movieBloc = MovieBloc(mockMovieApiService);
  });

  tearDown(() {
    movieBloc.close();
  });

  group('MovieBloc Tests', () {
    const testQuery = 'Batman';
    final testMovies = [
      Movie(
        title: 'Batman Begins',
        year: '2005',
        poster: 'https://example.com/batman.jpg',
        type: 'movie',
      ),
      Movie(
        title: 'Batman Returns',
        year: '1992',
        poster: 'https://example.com/batman-returns.jpg',
        type: 'movie',
      ),
    ];

    test('initial state is MovieInitial', () {
      expect(movieBloc.state, MovieInitial());
    });

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieLoaded] when movies are fetched successfully',
      setUp: () {
        // Arrange: Define the mock behavior
        when(() => mockMovieApiService.searchMovies(testQuery))
            .thenAnswer((_) async => testMovies);
      },
      build: () => movieBloc,
      act: (bloc) => bloc.add(SearchMovies(testQuery)),
      expect: () => [
        MovieLoading(),
        MovieLoaded(testMovies),
      ],
      verify: (_) {
        verify(() => mockMovieApiService.searchMovies(testQuery)).called(1);
      },
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when there is an error fetching movies',
      setUp: () {
        // Arrange: Define mock behavior for error
        when(() => mockMovieApiService.searchMovies(testQuery))
            .thenThrow(Exception('Failed to fetch movies'));
      },
      build: () => movieBloc,
      act: (bloc) => bloc.add(SearchMovies(testQuery)),
      expect: () => [
        MovieLoading(),
        MovieError('Exception: Failed to fetch movies'),
      ],
      verify: (_) {
        verify(() => mockMovieApiService.searchMovies(testQuery)).called(1);
      },
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when no movies are found',
      setUp: () {
        // Arrange: Define behavior when no movies are found
        when(() => mockMovieApiService.searchMovies(testQuery))
            .thenThrow(Exception('No movies found'));
      },
      build: () => movieBloc,
      act: (bloc) => bloc.add(SearchMovies(testQuery)),
      expect: () => [
        MovieLoading(),
        MovieError('Exception: No movies found'),
      ],
      verify: (_) {
        verify(() => mockMovieApiService.searchMovies(testQuery)).called(1);
      },
    );
  });
}

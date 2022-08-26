import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie.dart';

part 'similar_movies_state.dart';

class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  SimilarMoviesCubit({required this.movieRepository})
      : super(const SimilarMoviesState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchList(int movieId) async {
    try {
      final movieResponse = await movieRepository.getSimilarMovies(movieId);
      emit(SimilarMoviesState.success(movieResponse.movies));
    } on Exception {
      emit(const SimilarMoviesState.failure());
    }
  }
}

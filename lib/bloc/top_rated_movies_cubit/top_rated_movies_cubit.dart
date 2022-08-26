import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  TopRatedMoviesCubit({required this.movieRepository})
      : super(const TopRatedMoviesState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchTopRated() async {
    try {
      final movieResponse = await movieRepository.getTopRatedMovies();
      emit(TopRatedMoviesState.success(movieResponse.movies));
    } on Exception {
      emit(const TopRatedMoviesState.failure());
    }
  }
}

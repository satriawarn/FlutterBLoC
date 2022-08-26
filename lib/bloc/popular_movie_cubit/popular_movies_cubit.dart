import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie.dart';

part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit({required this.movieRepository})
      : super(const PopularMoviesState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchList() async {
    try {
      final movieResponse = await movieRepository.getPopuparMovies(1);
      emit(PopularMoviesState.success(movieResponse.movies));
    } on Exception {
      emit(const PopularMoviesState.failure());
    }
  }
}

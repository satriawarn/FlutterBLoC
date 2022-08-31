import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:meta/meta.dart';

import '../../model/movie.dart';

part 'search_movie_state.dart';

class SearchMovieCubit extends Cubit<SearchMovieState> {
  MovieRepository repository = MovieRepository();

  SearchMovieCubit() : super(SearchMovieInitial());

  Future<void> getSearchMovies(String query) async {
    try {
      emit(SearchMovieLoadInProgress());
      final movieResponse = await repository.getSearchMovie(query, 1);
      emit(SearchMovieLoadSuccess(movieResponse.movies));
    } catch (e) {
      emit(SearchMovieLoadFailure());
    }
  }

  void reset() => emit(SearchMovieInitial());
}

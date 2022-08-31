import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie.dart';

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  MovieRepository repository = MovieRepository();

  GenreCubit() : super(GenreInitial());

  Future<void> getMovieByGenreId(String query) async {
    try {
      emit(GenreLoadInProgress());
      final movieResponse = await repository.getMoviesByIdGenre(query, 1);
      emit(GenreLoadSuccess(movieResponse.movies));
    } catch (e) {
      emit(GenreLoadFailure());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie_detail.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({required this.movieRepository})
      : super(const MovieDetailState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchMovie(int id) async {
    try {
      final movieResponse = await movieRepository.getMovieDetail(id);
      emit(MovieDetailState.success(movieResponse.movieDetail));
    } on Exception {
      emit(const MovieDetailState.failure());
    }
  }
}

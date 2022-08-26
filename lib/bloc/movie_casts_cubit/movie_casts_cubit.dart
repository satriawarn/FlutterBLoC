import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/model/cast.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

part 'movie_casts_state.dart';

class MovieCastsCubit extends Cubit<MovieCastsState> {
  MovieCastsCubit({required this.movieRepository})
      : super(const MovieCastsState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchCasts(int movieId) async {
    try {
      final movieResponse = await movieRepository.getCasts(movieId);
      emit(MovieCastsState.success(movieResponse.casts));
    } on Exception {
      emit(const MovieCastsState.failure());
    }
  }
}

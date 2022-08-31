import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/trailers.dart';

part 'trailers_state.dart';

class TrailersCubit extends Cubit<TrailersState> {
  TrailersCubit({required this.movieRepository})
      : super(const TrailersState.loading());

  final MovieRepository movieRepository;

  Future<void> fetchTrailers(int movieId) async {
    try {
      final trailerResponse = await movieRepository.getTrailerMovie(movieId);
      emit(TrailersState.success(trailerResponse.trailers));
    } on Exception {
      emit(const TrailersState.failure());
    }
  }
}

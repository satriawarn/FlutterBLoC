import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../model/movie.dart';

part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit({required this.repository})
      : super(const NowPlayingState.loading());

  final MovieRepository repository;

  Future<void> fetchList() async {
    try {
      final movieResponse = await repository.getNowPlaying(1);
      emit(NowPlayingState.success(movieResponse.movies));
    } on Exception {
      emit(const NowPlayingState.failure());
    }
  }
}

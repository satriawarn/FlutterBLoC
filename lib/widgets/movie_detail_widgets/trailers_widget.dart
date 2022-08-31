import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/movie_detail_widgets/trailers_list_horizontal.dart';

import '../../bloc/trailers_cubit/trailers_cubit.dart';
import '../home_screen_widgets/movie_widgets_loader.dart';

class TrailersMovie extends StatelessWidget {
  const TrailersMovie({
    Key? key,
    required this.themeController,
    required this.movieRepository,
    required this.movieId,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrailersCubit(
        movieRepository: context.read<MovieRepository>(),
      )..fetchTrailers(movieId),
      child: TrailersView(
        movieId: movieId,
        movieRepository: movieRepository,
        themeController: themeController,
      ),
    );
  }
}

class TrailersView extends StatelessWidget {
  const TrailersView({
    Key? key,
    required this.movieId,
    required this.movieRepository,
    required this.themeController,
  }) : super(key: key);

  final int movieId;
  final MovieRepository movieRepository;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TrailersCubit>().state;

    switch (state.status) {
      case ListStatus.failure:
        return const Text(
          "Oops something went wrong",
          style: TextStyle(color: Colors.white),
        );
      case ListStatus.success:
        return TrailersListHorizontal(
          trailers: state.trailers,
          movieRepository: movieRepository,
          themeController: themeController,
        );
      default:
        return buildMovielistLoaderWidget(context);
    }
  }
}

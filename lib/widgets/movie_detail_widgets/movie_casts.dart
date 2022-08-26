import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/movie_casts_cubit/movie_casts_cubit.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/movie_widgets_loader.dart';

import 'cast_list_horizontal.dart';

class MovieCasts extends StatelessWidget {
  const MovieCasts({
    Key? key,
    required this.movieId,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieCastsCubit(
        movieRepository: context.read<MovieRepository>(),
      )..fetchCasts(movieId),
      child: CastsView(
        movieId: movieId,
        movieRepository: movieRepository,
        themeController: themeController,
      ),
    );
  }
}

class CastsView extends StatelessWidget {
  const CastsView({
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
    final state = context.watch<MovieCastsCubit>().state;

    switch (state.status) {
      case ListStatus.failure:
        return const Text(
          "Oops something went wrong",
          style: TextStyle(color: Colors.white),
        );
      case ListStatus.success:
        return CastsListHorizontal(
          casts: state.casts,
          movieRepository: movieRepository,
          themeController: themeController,
        );
      default:
        return buildMovielistLoaderWidget(context);
    }
  }
}

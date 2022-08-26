import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/similar_movie_cubit/similar_movies_cubit.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/movie_list_horizontal.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/movie_widgets_loader.dart';

class SimilarMoviesWidget extends StatelessWidget {
  const SimilarMoviesWidget({
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
      create: (_) => SimilarMoviesCubit(
        movieRepository: context.read<MovieRepository>(),
      )..fetchList(movieId),
      child: SimilarMoviesList(
        movieId: movieId,
        movieRepository: movieRepository,
        themeController: themeController,
      ),
    );
  }
}

class SimilarMoviesList extends StatelessWidget {
  const SimilarMoviesList({
    Key? key,
    required this.movieId,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final int movieId;
  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SimilarMoviesCubit>().state;

    switch (state.status) {
      case ListStatus.failure:
        return const Center(
          child: Text(
            "Oops something went wrong",
            style: TextStyle(color: Colors.white),
          ),
        );
      case ListStatus.success:
        return MovieListHorizontal(
          movies: state.movies,
          themeController: themeController,
          movieRepository: movieRepository,
        );
      default:
        return buildMovielistLoaderWidget(context);
    }
  }
}

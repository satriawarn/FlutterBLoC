import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/bloc/top_rated_movies_cubit/top_rated_movies_cubit.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/movie_list_horizontal.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/movie_widgets_loader.dart';

class TopRatedMovieList extends StatelessWidget {
  const TopRatedMovieList({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopRatedMoviesCubit(
        movieRepository: context.read<MovieRepository>(),
      )..fetchTopRated(),
      child: TopRatedMovieView(
        themeController: themeController,
        movieRepository: movieRepository,
      ),
    );
  }
}

class TopRatedMovieView extends StatelessWidget {
  const TopRatedMovieView({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TopRatedMoviesCubit>().state;
    switch (state.status) {
      case ListStatus.failure:
        return const Center(
          child: Text('Oops something went wrong'),
        );
      case ListStatus.success:
        if (state.movies.isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "No More Top Rated Movies",
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          );
        } else {
          return MovieListHorizontal(
            movies: state.movies,
            themeController: themeController,
            movieRepository: movieRepository,
          );
        }
      default:
        return buildMovielistLoaderWidget(context);
    }
  }
}

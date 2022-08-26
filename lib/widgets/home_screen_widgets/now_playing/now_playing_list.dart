import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../../../bloc/now_playing_cubit/now_playing_cubit.dart';
import '../movie_list_horizontal.dart';
import '../movie_widgets_loader.dart';

class NowPlayingList extends StatelessWidget {
  const NowPlayingList(
      {Key? key, required this.themeController, required this.movieRepository})
      : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NowPlayingCubit(
        repository: context.read<MovieRepository>(),
      )..fetchList(),
      child: NowPlayingView(
        themeController: themeController,
        movieRepository: movieRepository,
      ),
    );
  }
}

class NowPlayingView extends StatelessWidget {
  const NowPlayingView(
      {Key? key, required this.themeController, required this.movieRepository})
      : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NowPlayingCubit>().state;
    switch (state.status) {
      case ListStatus.failure:
        return const Center(child: Text('Oops something went wrong'));
      case ListStatus.success:
        if (state.movies.isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Text(
                      "No More Popular Movies",
                      style: TextStyle(color: Colors.black45),
                    )
                  ],
                )
              ],
            ),
          );
        } else {
          return MovieListHorizontal(
            movies: state.movies,
            movieRepository: movieRepository,
            themeController: themeController,
          );
        }
      default:
        return buildMovielistLoaderWidget(context);
    }
  }
}

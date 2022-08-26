import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../widgets/home_screen_widgets/now_playing/now_playing_widget.dart';
import '../widgets/home_screen_widgets/popular_movies/popular_movies_widget.dart';
import '../widgets/home_screen_widgets/top_rated/top_rated_movies_widgets.dart';
import '../widgets/home_screen_widgets/upcoming/upcoming_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key, required this.themeController, required this.movieRepository})
      : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          UpComingWidget(
            movieRepository: widget.movieRepository,
            themeController: widget.themeController,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Now Playing"),
          ),
          NowPlayingWidget(
            movieRepository: widget.movieRepository,
            themeController: widget.themeController,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Popular Movies"),
          ),
          PopularMoviesWidget(
            movieRepository: widget.movieRepository,
            themeController: widget.themeController,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Top Rated Movies"),
          ),
          TopRatedMoviesWidget(
            movieRepository: widget.movieRepository,
            themeController: widget.themeController,
          )
        ],
      ),
    );
  }
}

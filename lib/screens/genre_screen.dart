import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/genre_cubit/genre_cubit.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/screens/genre_list_screen.dart';
import 'package:flutter_state_bloc/utils/next_screen.dart';
import 'package:flutter_state_bloc/utils/snack_bar.dart';

import '../model/genre_model.dart';

class GenreScreen extends StatelessWidget {
  const GenreScreen({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    final genres = GenresList.fromJson(genreslist).list;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Popular Genres",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 28 / 16),
                children: [
                  for (var i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GenreTile(
                        themeController: themeController,
                        movieRepository: movieRepository,
                        genre: genres[i],
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Browse All",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 28 / 16,
                ),
                children: [
                  for (var i = 4; i < genres.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GenreTile(
                        themeController: themeController,
                        movieRepository: movieRepository,
                        genre: genres[i],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenreTile extends StatelessWidget {
  const GenreTile({
    Key? key,
    required this.themeController,
    required this.movieRepository,
    required this.genre,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;
  final Genres genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            BlocProvider(
              create: (context) => GenreCubit()..getMovieByGenreId(genre.id),
              child: GenreResults(
                themeController: themeController,
                movieRepository: movieRepository,
                query: genre.name,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: genre.color,
            child: Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: -5,
                  right: -20,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(380 / 360),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: genre.image,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 75,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    genre.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

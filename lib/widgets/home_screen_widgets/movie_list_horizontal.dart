import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/utils/snack_bar.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../model/movie.dart';
import '../../screens/movie_detail_screen.dart';

class MovieListHorizontal extends StatelessWidget {
  const MovieListHorizontal({
    Key? key,
    required this.movies,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final List<Movie> movies;
  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                      themeController: themeController,
                      movieRepository: movieRepository,
                      movieId: movies[index].id,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Stack(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.black87,
                          highlightColor: Colors.white54,
                          enabled: true,
                          child: const SizedBox(
                            height: 160.0,
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Icon(
                                FontAwesome5.film,
                                color: Colors.black26,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 160.0,
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w300/${movies[index].poster}",
                                errorBuilder: (context, exception, stackTrace) {
                                  return const Icon(FontAwesome5.film);
                                },
                              ),
                              // FadeInImage.memoryNetwork(
                              //   fit: BoxFit.cover,
                              //   placeholder: kTransparentImage,
                              //   image:
                              //       "https://image.tmdb.org/t/p/w300/${movies[index].poster}",
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

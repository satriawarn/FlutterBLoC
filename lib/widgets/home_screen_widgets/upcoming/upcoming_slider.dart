import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/bloc/upcoming_bloc_cubit/upcoming_cubit.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/home_screen_widgets/upcoming/upcoming_loader.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../screens/movie_detail_screen.dart';

class UpComingSlider extends StatelessWidget {
  const UpComingSlider({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpComingCubit(
        repository: context.read<MovieRepository>(),
      )..fetchUpComing(),
      child: UpComingView(
        themeController: themeController,
        movieRepository: movieRepository,
      ),
    );
  }
}

class UpComingView extends StatelessWidget {
  const UpComingView({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UpComingCubit>().state;
    switch (state.status) {
      case ListStatus.failure:
        return const Center(child: Text('Oops something went wrong!'));
      case ListStatus.success:
        return Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 1.0,
                aspectRatio: 2 / 2.8,
                enlargeCenterPage: true,
              ),
              items: state.movies
                  .map((movie) => Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    themeController: themeController,
                                    movieRepository: movieRepository,
                                    movieId: movie.id,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.black87,
                                  highlightColor: Colors.white54,
                                  child: const AspectRatio(
                                    aspectRatio: 2 / 2.8,
                                    child: Icon(
                                      FontAwesome5.film,
                                      color: Colors.black26,
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 2 / 2.8,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage.memoryNetwork(
                                        fit: BoxFit.cover,
                                        alignment: Alignment.bottomCenter,
                                        placeholder: kTransparentImage,
                                        image:
                                            "https://image.tmdb.org/t/p/original/${movie.poster}"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 5.0,
                            right: 10.0,
                            child: SafeArea(
                              child: Column(
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            Positioned(
              left: 10.0,
              top: 10.0,
              child: SafeArea(
                child: Text(
                  "Upcoming movies",
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 18.0,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return buildLoadingUpcomingWidget(context);
    }
  }
}

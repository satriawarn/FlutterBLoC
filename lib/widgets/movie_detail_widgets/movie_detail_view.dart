import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_state_bloc/bloc/movie_detail_cubit/movie_detail_cubit.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../bloc/theme_bloc/theme_controller.dart';
import '../../repository/movie_repository.dart';
import 'cast_widget_loader.dart';
import 'movie_casts.dart';
import 'similar_movies.dart';

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({
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
    return Scaffold(
      body: BlocProvider(
        create: (_) => MovieDetailCubit(
          movieRepository: context.read<MovieRepository>(),
        )..fetchMovie(movieId),
        child: DetailView(
          movieId: movieId,
          movieRepository: movieRepository,
          themeController: themeController,
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.movieId,
    required this.movieRepository,
    required this.themeController,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat();
    final state = context.watch<MovieDetailCubit>().state;

    switch (state.status) {
      case ListStatus.failure:
        return const Center(
          child: Text(
            'Oops something went wrong',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      case ListStatus.success:
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.white54,
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                            ),
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 3 / 2,
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            fit: BoxFit.cover,
                            image:
                                "https://image.tmdb.org/t/p/original/${state.movie.backPoster}"),
                      ),
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(1.0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 10.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.white10,
                                highlightColor: Colors.white30,
                                enabled: true,
                                child: SizedBox(
                                  height: 120.0,
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.black12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0)),
                                height: 120.0,
                                child: AspectRatio(
                                  aspectRatio: 2 / 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          "https://image.tmdb.org/t/p/w200/${state.movie.poster}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  state.movie.title,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Release date: ${state.movie.releaseDate}",
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5.0,
                    child: SafeArea(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          EvaIcons.arrowIosBack,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        EvaIcons.clockOutline,
                        size: 15.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        getDuration(state.movie.runtime),
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 40.0,
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.movie.genres.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        color: Colors.white.withOpacity(0.1)),
                                    child: Text(
                                      state.movie.genres[index].name,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        height: 1.4,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9.0,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        EvaIcons.barChart,
                        size: 15.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        state.movie.vote_average.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      RatingBar(
                        itemSize: 10.0,
                        initialRating: state.movie.vote_average / 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                        ratingWidget: RatingWidget(
                          full: const Icon(EvaIcons.star, color: Colors.amber),
                          half: const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          empty: const Icon(
                            EvaIcons.starOutline,
                            color: Colors.orange,
                          ),
                        ),
                        onRatingUpdate: (value) {
                          print("rating");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Overview",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    state.movie.overview,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Casts",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RepositoryProvider.value(
                    value: movieRepository,
                    child: MovieCasts(
                      themeController: themeController,
                      movieRepository: movieRepository,
                      movieId: movieId,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "About Movie",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status : ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        state.movie.status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Budget : ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "\$ ${currencyFormatter.format(state.movie.budget)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Revenue : ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "\$ ${currencyFormatter.format(state.movie.revenue)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Text(
                      "Similar Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: RepositoryProvider.value(
                      value: movieRepository,
                      child: SimilarMoviesWidget(
                        themeController: themeController,
                        movieRepository: movieRepository,
                        movieId: movieId,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        );
      default:
        return buildCastslistLoaderWidget(context);
    }
  }

  String getDuration(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h ${parts[1].padLeft(2, '0')}min';
  }
}

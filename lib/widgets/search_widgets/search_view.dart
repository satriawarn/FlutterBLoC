import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/serach_movie_cubit/search_movie_cubit.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/search_widgets/search_item_card.dart';
import 'package:flutter_state_bloc/widgets/search_widgets/search_loading.dart';

import '../home_screen_widgets/movie_widgets_loader.dart';
import '../home_screen_widgets/upcoming/upcoming_loader.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchMovieCubit(),
      child: SearchMovieView(
        themeController: themeController,
        movieRepository: movieRepository,
      ),
    );
  }
}

class SearchMovieView extends StatelessWidget {
  const SearchMovieView({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    // final state = context.watch<SearchMovieCubit>().state;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xff26282F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      EvaIcons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Search',
                        ),
                        key: const Key('enterMovieQuery'),
                        onChanged: (query) {
                          context
                              .read<SearchMovieCubit>()
                              .getSearchMovies(query);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<SearchMovieCubit, SearchMovieState>(
                builder: (context, state) {
                  if (state is SearchMovieLoadInProgress) {
                    return buildSearchMovieLoaderWidget(context);
                  } else if (state is SearchMovieLoadSuccess) {
                    final result = state.searchMovieResult;
                    if (result.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: result.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final movie = result[index];
                            return ItemCard(
                              themeController: themeController,
                              movieRepository: movieRepository,
                              movie: movie,
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text("Not Found"),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

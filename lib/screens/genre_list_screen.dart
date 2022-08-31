import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/genre_cubit/genre_cubit.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import '../widgets/search_widgets/search_item_card.dart';

class GenreResults extends StatefulWidget {
  const GenreResults({
    Key? key,
    required this.themeController,
    required this.movieRepository,
    required this.query,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;
  final String query;
  @override
  State<GenreResults> createState() => _GenreResultsState();
}

class _GenreResultsState extends State<GenreResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GenreCubit, GenreState>(
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  BlocBuilder<GenreCubit, GenreState>(
                    builder: (context, state) {
                      if (state is GenreLoadInProgress) {
                        return Center(
                          child: Transform.scale(
                            scale: 1,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else if (state is GenreLoadSuccess) {
                        final result = state.genreMovieResult;
                        if (result.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: result.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final movie = result[index];
                                return ItemCard(
                                  themeController: widget.themeController,
                                  movieRepository: widget.movieRepository,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade900,
                        width: .6,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              Text(
                                widget.query,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

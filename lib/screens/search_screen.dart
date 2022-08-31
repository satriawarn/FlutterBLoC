import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/widgets/search_widgets/search_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return SearchWidget(
      movieRepository: movieRepository,
      themeController: themeController,
    );
  }
}

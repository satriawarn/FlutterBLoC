import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import 'app.dart';
import 'app_config.dart';
import 'bloc/theme_bloc/theme_controller.dart';
import 'bloc/theme_bloc/theme_service.dart';

void main() async {
  final movieRepository = MovieRepository();
  final themeController = ThemeController(ThemeService());
  await themeController.loadSettings();

  var configuredApp = AppConfig(
    environment: Environment.prod,
    appTitle: 'Movie App',
    child: App(
      themeController: themeController,
      movieRepository: movieRepository,
    ),
  );

  runApp(configuredApp);
}

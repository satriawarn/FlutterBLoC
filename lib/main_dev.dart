import 'package:flutter/cupertino.dart';
import 'package:flutter_state_bloc/app.dart';
import 'package:flutter_state_bloc/app_config.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';

import 'bloc/theme_bloc/theme_controller.dart';
import 'bloc/theme_bloc/theme_service.dart';

void main() async {
  final movieRepository = MovieRepository();
  final themeController = ThemeController(ThemeService());
  await themeController.loadSettings();

  var configuredApp = AppConfig(
    environment: Environment.dev,
    appTitle: '[DEV] Movie App',
    child: App(
      themeController: themeController,
      movieRepository: movieRepository,
    ),
  );

  runApp(configuredApp);
}

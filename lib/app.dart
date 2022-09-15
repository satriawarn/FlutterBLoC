import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/app_config.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/style/custom_theme.dart';

import 'screens/main_screen.dart';

class App extends StatelessWidget {
  const App(
      {Key? key, required this.themeController, required this.movieRepository})
      : super(key: key);

  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: AppConfig.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: MainScreen(
            themeController: themeController,
            movieRepository: movieRepository,
          ),
        );
      },
    );
  }
}

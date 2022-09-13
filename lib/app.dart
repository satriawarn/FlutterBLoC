import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/features/weather/domain/repositories/weather_repository.dart';

import 'features/weather/presentation/pages/weather_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.weatherRepository,
  }) : super(key: key);
  final WeatherRepository weatherRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WeatherRepository>.value(value: weatherRepository),
      ],
      child: const MainAppView(),
    );
  }
}

class MainAppView extends StatefulWidget {
  const MainAppView({Key? key}) : super(key: key);

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(),
    );
  }
}

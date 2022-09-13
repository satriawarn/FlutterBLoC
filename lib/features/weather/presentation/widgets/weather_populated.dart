import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/core/presentation/temperature_units.dart';

import '../../domain/entities/weather.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    Key? key,
    required this.units,
    required this.weather,
  }) : super(key: key);

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        _WeatherBackground(),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 48,
                ),
                _WeatherIcon(condition: weather.condition),
                Text(
                  weather.location,
                  style: theme.textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  '''${weather.temperature.toStringAsFixed(1)}°${units.isCelcius ? 'C' : 'F'}''',
                  style: theme.textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '''Last Updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  weather.condition.name,
                  style: theme.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.25, 0.75, 0.90, 1.0],
          colors: [
            color,
            color.brighten(10),
            color.brighten(33),
            color.brighten(50),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({
    Key? key,
    required this.condition,
  }) : super(key: key);

  static const _iconSize = 80.0;

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(fontSize: _iconSize),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
      default:
        return '❓';
    }
  }
}

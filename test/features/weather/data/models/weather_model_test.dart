import 'dart:convert';

import 'package:flutter_state_bloc/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final tWeatherModel = WeatherModel(
    generationtimeMs: 0.29098987579345703,
    longitude: 110.375,
    latitude: -7.875,
    elevation: 0.0,
    utcOffsetSeconds: 0,
    currentWeather: WeatherInfoModel(
      lastUpdated: DateTime(2022, 09, 09, 00),
      temperature: 25.2,
      windDirection: 37.0,
      windSpeed: 1.8,
      weatherCode: WeatherCode.fog,
    ),
  );

  group('WeatherModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        final jsonMap = jsonDecode(fixture('weather.json'));

        final result = WeatherModel.fromJson(jsonMap);

        expect(result, tWeatherModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        final result = tWeatherModel.toJson();

        final expectedMap = {
          "generationtime_ms": 0.29098987579345703,
          "longitude": 110.375,
          "latitude": -7.875,
          "elevation": 0.0,
          "utc_offset_seconds": 0,
          "current_weather": WeatherInfoModel(
            lastUpdated: DateTime(2022, 09, 09, 00),
            temperature: 25.2,
            windDirection: 37.0,
            windSpeed: 1.8,
            weatherCode: WeatherCode.fog,
          )
        };

        expect(result, expectedMap);
      });
    });
  });
}

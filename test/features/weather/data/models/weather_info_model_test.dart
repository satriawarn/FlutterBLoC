import 'dart:convert';

import 'package:flutter_state_bloc/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final tWeatherInfoModel = WeatherInfoModel(
    lastUpdated: DateTime(2022, 09, 09, 00),
    temperature: 25.2,
    windDirection: 37.0,
    windSpeed: 1.8,
    weatherCode: WeatherCode.fog,
  );

  group('WeatherInfoModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        final jsonMap = jsonDecode(fixture('weather_info.json'));

        final result = WeatherInfoModel.fromJson(jsonMap);

        expect(result, tWeatherInfoModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        final result = tWeatherInfoModel.toJson();

        final expectedMap = {
          "time": "2022-09-09T00:00:00.000",
          "temperature": 25.2,
          "winddirection": 37.0,
          "windspeed": 1.8,
          "weathercode": 45,
        };

        expect(result, expectedMap);
      });
    });
  });
}

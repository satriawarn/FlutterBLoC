import 'dart:convert';

import 'package:flutter_state_bloc/core/error/exceptions.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_model.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_local_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WeatherLocalDataSourceImpl weatherLocalDataSourceImpl;
  late SharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    weatherLocalDataSourceImpl = WeatherLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  group('WeatherLocalDataSourceImpl', () {
    group('getLastWeather', () {
      final tRawWeather = fixture('weather.json');
      final tWeatherModel = WeatherModel.fromJson(jsonDecode(tRawWeather));

      test(
          'return Weather from SharedPreferences when there is one in the cache',
          () async {
        when(() => sharedPreferences.getString(any())).thenReturn(tRawWeather);

        final result = await weatherLocalDataSourceImpl.getLastWeather();

        verify(() => sharedPreferences.getString(CACHED_WEATHER));
        expect(result, tWeatherModel);
      });

      test('throws CacheException when there is not a cache value', () async {
        when(() => sharedPreferences.getString(any())).thenReturn(null);

        final call = weatherLocalDataSourceImpl.getLastWeather();

        expect(call, throwsA(isA<CacheException>()));
      });
    });

    group('getName', () {
      const tName = 'Yogyakarta';

      test(
          'return String from SharedPreferences when there is one in the cache',
          () async {
        when(() => sharedPreferences.getString(any())).thenReturn(tName);

        final result = await weatherLocalDataSourceImpl.getLastName();

        verify(() => sharedPreferences.getString(CACHED_LOCATION_NAME));
        expect(result, tName);
      });

      test('throws CacheException when there is not a cache value', () async {
        when(() => sharedPreferences.getString(any())).thenReturn(null);

        final call = weatherLocalDataSourceImpl.getLastWeather();

        expect(call, throwsA(isA<CacheException>()));
      });

      group('cacheWeather', () {
        final tWeather = WeatherModel(
          generationtimeMs: 1,
          longitude: 1,
          latitude: 2,
          elevation: 3,
          utcOffsetSeconds: 4,
          currentWeather: WeatherInfoModel(
            lastUpdated: DateTime(1),
            temperature: 1,
            windDirection: 2,
            windSpeed: 3,
            weatherCode: WeatherCode.clearSky,
          ),
        );

        final rawWeather = jsonEncode(tWeather.toJson());

        test('call SharedPreference to cache the data', () async {
          try {
            await weatherLocalDataSourceImpl.cacheWeather(tWeather);
          } catch (_) {}

          verify(
            () => sharedPreferences.setString(CACHED_WEATHER, rawWeather),
          ).called(1);
        });
      });

      group('cacheName', () {
        const tName = 'test';

        test('call SharedPreference to cache the data', () async {
          try {
            await weatherLocalDataSourceImpl.cacheName(tName);
          } catch (_) {}

          verify(
            () => sharedPreferences.setString(CACHED_LOCATION_NAME, tName),
          ).called(1);
        });
      });
    });
  });
}

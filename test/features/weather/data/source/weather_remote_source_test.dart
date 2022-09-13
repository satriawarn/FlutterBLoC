import 'dart:convert';

import 'package:flutter_state_bloc/core/error/exceptions.dart';
import 'package:flutter_state_bloc/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_model.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_remote_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  late WeatherRemoteDataImpl weatherRemoteDataImpl;
  late http.Client client;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    client = MockHttpClient();
    weatherRemoteDataImpl = WeatherRemoteDataImpl(client: client);
  });

  group('WeatherRemoteDataSource', () {
    group('getForecastByLatLong', () {
      const tLat = 1.0;
      const tLong = 2.0;
      final tWeatherModel =
          WeatherModel.fromJson(jsonDecode(fixture('weather.json')));

      test('''perform a GET request on a URL with number 
      being the endpoint and with application/json''', () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('weather.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        try {
          await weatherRemoteDataImpl.getForecastByLatLong(tLat, tLong);
        } catch (_) {}
        // assert
        verify(
          () => client.get(
            Uri.parse(
              'https://api.open-meteo.com/v1/forecast?latitude=$tLat&longitude=$tLong&timezone=UTC&current_weather=true',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('return weatherModel when the response code is 200', () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('weather.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        final result =
            await weatherRemoteDataImpl.getForecastByLatLong(tLat, tLong);
        expect(result, tWeatherModel);
      });

      test('throws a ServerException when the response code is 404 or others',
          () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn('Any Data');
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);

        final call = weatherRemoteDataImpl.getForecastByLatLong(tLat, tLong);

        expect(call, throwsA(isA<ServerException>()));
      });
    });

    group('getGeoByCity', () {
      const tCity = 'Yogyakarta';
      final tGeoCollectionModel =
          GeoCollectionModel.fromJson(jsonDecode(fixture('geo_result.json')));

      test('''perform a GET request on a URL with number 
      being the endpoint and with application/json''', () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('geo_result.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        try {
          await weatherRemoteDataImpl.getGeoByKeyword(tCity);
        } catch (_) {}
        // assert
        verify(
          () => client.get(
            Uri.parse(
              'https://geocoding-api.open-meteo.com/v1/search?name=$tCity&count=1',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('return GeoCollectionModel when the response code is 200', () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('geo_result.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);

        final result = await weatherRemoteDataImpl.getGeoByKeyword(tCity);

        expect(result, tGeoCollectionModel);
      });

      test('throws a ServerException when the response code is 404 or others',
          () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn('Any Data');
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);

        final call = weatherRemoteDataImpl.getGeoByKeyword(tCity);

        expect(call, throwsA(isA<ServerException>()));
      });
    });
  });
}

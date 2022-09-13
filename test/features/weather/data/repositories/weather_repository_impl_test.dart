import 'package:dartz/dartz.dart';
import 'package:flutter_state_bloc/core/error/exceptions.dart';
import 'package:flutter_state_bloc/core/error/failures.dart';
import 'package:flutter_state_bloc/core/network/network_info.dart';
import 'package:flutter_state_bloc/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/geo_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_model.dart';
import 'package:flutter_state_bloc/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_local_data.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_remote_data.dart';
import 'package:flutter_state_bloc/features/weather/domain/entities/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGeoCollectionModel extends Mock implements GeoCollectionModel {}

class MockGeoModel extends Mock implements GeoModel {}

class MockWeatherModel extends Mock implements WeatherModel {}

class MockWeahterInfoModel extends Mock implements WeatherInfoModel {}

void main() {
  late WeatherRepositoryImpl repository;
  late WeatherRemoteDataSource remoteDataSource;
  late WeatherLocalDataSource localDataSource;
  late NetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockWeatherRemoteDataSource();
    localDataSource = MockWeatherLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('WeatherRepositoryImpl', () {
    group('getForecastByName', () {
      const tName = 'Yogyakarta';
      const tLatitude = -7.80139;
      const tLongitude = 110.36472;
      const tWeatherCode = WeatherCode.clearSky;
      const tTemperature = 25.2;
      final tLastUpdated = DateTime(2022, 09, 09, 09);
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: tLastUpdated,
        location: tName,
        temperature: tTemperature,
      );

      test('check if the device is online', () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        try {
          await repository.getForecastByName(tName);
        } catch (_) {
          verify(() => networkInfo.isConnected);
        }
      });

      group('device is online', () {
        setUp(() {
          when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('call getGeoByName with correct keyword', () async {
          try {
            await repository.getForecastByName(tName);
          } catch (_) {
            verify(() => remoteDataSource.getGeoByKeyword(tName)).called(1);
          }
        });

        test('return server failure when getGeoByName throws', () async {
          final exception = Exception('oops!');

          when(() => remoteDataSource.getGeoByKeyword(any()))
              .thenThrow(exception);

          final result = await repository.getForecastByName(tName);

          expect(result, Left(ServerFailure()));
        });

        test('return server failure when getGeoByName has no results',
            () async {
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModels = <GeoModel>[];

          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);

          final result = await repository.getForecastByName(tName);

          expect(result, Left(ServerFailure()));
        });

        test('call getForecastByLatLong with correct lat and long', () async {
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);

          await repository.getForecastByName(tName);

          verify(() => remoteDataSource.getForecastByLatLong(
                tLatitude,
                tLongitude,
              )).called(1);
        });

        test('return server failure when getForecastByLatLong throws',
            () async {
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() => remoteDataSource.getForecastByLatLong(any(), any()))
              .thenThrow(Exception());

          final result = await repository.getForecastByName(tName);

          expect(result, Left(ServerFailure()));
        });

        test(
            'cache weather data locally when the call to remote data source is successful',
            () async {
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLatLong(tLatitude, tLongitude))
              .thenAnswer((_) async => mockWeatherModel);

          try {
            await repository.getForecastByName(tName);
          } catch (_) {}

          verify(() => localDataSource.cacheWeather(mockWeatherModel))
              .called(1);
        });

        test(
            'cache name locally when the call to remote data source is successful',
            () async {
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLatLong(tLatitude, tLongitude))
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.cacheWeather(mockWeatherModel))
              .thenAnswer((_) async => {});
          when(() => localDataSource.cacheName(tName))
              .thenAnswer((_) async => {});

          final result = await repository.getForecastByName(tName);

          expect(result, Right(tWeather));
          verify(() =>
                  remoteDataSource.getForecastByLatLong(tLatitude, tLongitude))
              .called(1);
        });

        test('return correct model with all correct datas', () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLatLong(tLatitude, tLongitude))
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.cacheWeather(mockWeatherModel))
              .thenAnswer((_) async => {});
          when(() => localDataSource.cacheName(tName))
              .thenAnswer((_) async => {});

          final result = await repository.getForecastByName(tName);

          expect(result, Right(tWeather));
          verify(() =>
                  remoteDataSource.getForecastByLatLong(tLatitude, tLongitude))
              .called(1);
        });
      });

      group('device is offline', () {
        setUp(() {
          when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('return last locally cached data when the cached data is present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.getLastName())
              .thenAnswer((_) async => tName);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Right(tWeather));
          verify(() => localDataSource.getLastWeather()).called(1);
          verify(() => localDataSource.getLastName()).called(1);
        });

        test(
            'return CacheFailure on getName when there is no cached data present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenThrow(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.getLastName()).thenThrow(CacheException());
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(CacheFailure()));
          verify(() => localDataSource.getLastName()).called(1);
        });

        test(
            'return CacheFailure on getLastWeather when there is no cached data present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeahterInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenThrow(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenThrow(CacheException());
          when(() => localDataSource.getLastName())
              .thenAnswer((_) async => tName);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(CacheFailure()));
          verify(() => localDataSource.getLastWeather()).called(1);
        });
      });
    });
  });
}

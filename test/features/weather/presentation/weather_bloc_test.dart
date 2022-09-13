import 'package:dartz/dartz.dart';
import 'package:flutter_state_bloc/core/error/failures.dart';
import 'package:flutter_state_bloc/core/network/network_status.dart';
import 'package:flutter_state_bloc/core/presentation/temperature_units.dart';
import 'package:flutter_state_bloc/features/weather/domain/entities/weather.dart';
import 'package:flutter_state_bloc/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:flutter_state_bloc/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetForecastByName extends Mock implements GetForecastByName {}

void main() {
  late WeatherBloc bloc;
  late GetForecastByName getForecastByName;

  setUpAll(() {
    registerFallbackValue(const GetForecastByNameParams(locationName: ''));
  });

  setUp(() {
    getForecastByName = MockGetForecastByName();
    bloc = WeatherBloc(getForecastByName: getForecastByName);
  });

  group('WeatherBloc', () {
    test('initialState is correct', () {
      expect(
        WeatherBloc(getForecastByName: getForecastByName).state,
        const WeatherState(),
      );
    });

    group('WeatherSearched', () {
      const tName = 'Yogyakarta';
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: tName,
        temperature: 25.2,
      );

      test('get data from getForecastByNameUse', () async {
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));

        bloc.add(const WeatherSearched(keyword: tName));
        await bloc.close();

        verify(
          () => getForecastByName(
            const GetForecastByNameParams(locationName: tName),
          ),
        ).called(1);
      });

      test('emits [loading, success] when data is gotten successfully',
          () async {
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));

        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(networkStatus: NetworkStatus.loading),
              WeatherState(
                networkStatus: NetworkStatus.success,
                weather: tWeather,
              ),
            ],
          ),
        );

        bloc.add(const WeatherSearched(keyword: tName));
        await bloc.close();
      });

      test('emits [loading, failure] when getting data fails', () async {
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(networkStatus: NetworkStatus.loading),
              const WeatherState(
                networkStatus: NetworkStatus.failure,
                message: SERVER_FAILURE_MESSAGE,
              ),
            ],
          ),
        );

        bloc.add(const WeatherSearched(keyword: tName));
        await bloc.close();
      });

      test(
          'emits [loading, failure] with a proper message fot the error when getting data fails',
          () async {
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Left(CacheFailure()));

        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(networkStatus: NetworkStatus.loading),
              const WeatherState(
                networkStatus: NetworkStatus.failure,
                message: CACHED_FAILURE_MESSAGE,
              ),
            ],
          ),
        );

        bloc.add(const WeatherSearched(keyword: tName));
        await bloc.close();
      });
    });

    group('WeatherUnitChanged', () {
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: 'Yogyakarta',
        temperature: 25.2,
      );
      final tWeatherFahrenheit = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: 'Yogyakarta',
        temperature: 5.0,
      );

      test('change unit for state', () async {
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(
                units: TemperatureUnits.fahrenheit,
              ),
            ],
          ),
        );

        bloc.add(
          const WeatherUnitChanged(
            units: TemperatureUnits.fahrenheit,
          ),
        );
        await bloc.close();
      });

      test('temperature changed for fahrenheit', () async {
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));

        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(networkStatus: NetworkStatus.loading),
              WeatherState(
                networkStatus: NetworkStatus.success,
                weather: tWeather,
              ),
              WeatherState(
                networkStatus: NetworkStatus.success,
                units: TemperatureUnits.fahrenheit,
                weather: Weather(
                  condition: tWeather.condition,
                  lastUpdated: tWeather.lastUpdated,
                  location: tWeather.location,
                  temperature: tWeather.temperature.toFahrenheit(),
                ),
              )
            ],
          ),
        );

        bloc.add(const WeatherSearched(keyword: 'Yogyakarta'));
        bloc.add(
          const WeatherUnitChanged(
            units: TemperatureUnits.fahrenheit,
          ),
        );

        await bloc.close();
      });

      test('temperature changed for celsius', () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeatherFahrenheit));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(networkStatus: NetworkStatus.loading),
              WeatherState(
                  networkStatus: NetworkStatus.success,
                  weather: tWeatherFahrenheit),
              WeatherState(
                networkStatus: NetworkStatus.success,
                units: TemperatureUnits.fahrenheit,
                weather: Weather(
                  condition: tWeatherFahrenheit.condition,
                  lastUpdated: tWeatherFahrenheit.lastUpdated,
                  location: tWeatherFahrenheit.location,
                  temperature: tWeatherFahrenheit.temperature.toFahrenheit(),
                ),
              ),
              WeatherState(
                networkStatus: NetworkStatus.success,
                units: TemperatureUnits.celcius,
                weather: Weather(
                  condition: tWeatherFahrenheit.condition,
                  lastUpdated: tWeatherFahrenheit.lastUpdated,
                  location: tWeatherFahrenheit.location,
                  temperature: tWeatherFahrenheit.temperature,
                ),
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: 'Yogyakarta'));
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.fahrenheit,
        ));
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.celcius,
        ));
        await bloc.close();
      });
    });
  });
}

extension on double {
  double toFahrenheit() => ((this * 9 / 5) + 32);
}

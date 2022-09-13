import 'package:dartz/dartz.dart';
import 'package:flutter_state_bloc/features/weather/domain/entities/weather.dart';
import 'package:flutter_state_bloc/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_state_bloc/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastByName usecase;
  late WeatherRepository weatherRepository = MockWeatherRepository();
  setUp(() {
    weatherRepository = MockWeatherRepository();
    usecase = GetForecastByName(weatherRepository: weatherRepository);
  });

  const tLocationName = 'Yogyakarta';
  const tTemperature = 25.2;
  final tWeather = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(1),
    location: tLocationName,
    temperature: tTemperature,
  );

  group('Usecase: GetForecastByName', () {
    test('should get forecase for weather from the repository', () async {
      when(() => weatherRepository.getForecastByName(any()))
          .thenAnswer((_) async => Right(tWeather));

      final result = await usecase(
        const GetForecastByNameParams(locationName: tLocationName),
      );

      expect(result, Right(tWeather));
      verify(() => weatherRepository.getForecastByName(tLocationName));
      verifyNoMoreInteractions(weatherRepository);
    });
  });
}

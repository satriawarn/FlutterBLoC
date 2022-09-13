import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/core/error/failures.dart';
import 'package:flutter_state_bloc/core/usecases/usecase.dart';
import 'package:flutter_state_bloc/features/weather/domain/repositories/weather_repository.dart';

import '../entities/weather.dart';

class GetForecastByName implements UseCase<Weather, GetForecastByNameParams> {
  final WeatherRepository weatherRepository;
  GetForecastByName({
    required this.weatherRepository,
  });

  @override
  Future<Either<Failure, Weather>> call(params) {
    return weatherRepository.getForecastByName(params.locationName);
  }
}

class GetForecastByNameParams extends Equatable {
  final String locationName;
  const GetForecastByNameParams({
    required this.locationName,
  });

  @override
  List<Object> get props => [locationName];
}

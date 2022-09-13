import 'package:dartz/dartz.dart';
import 'package:flutter_state_bloc/core/error/failures.dart';

import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getForecastByName(String name);
}

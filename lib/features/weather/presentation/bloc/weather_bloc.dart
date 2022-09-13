import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_state_bloc/core/error/failures.dart';
import 'package:flutter_state_bloc/core/network/network_status.dart';
import 'package:flutter_state_bloc/core/presentation/temperature_units.dart';
import 'package:flutter_state_bloc/features/weather/domain/usecases/get_forecast_by_name.dart';

import '../../domain/entities/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const CACHED_FAILURE_MESSAGE = 'Cache Failure';
const SERVER_FAILURE_MESSAGE = 'Server Failure';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.getForecastByName}) : super(const WeatherState()) {
    on<WeatherSearched>(_onWeatherSearched);
    on<WeatherUnitChanged>(_onWeatherUnitChanged);
  }

  final GetForecastByName getForecastByName;

  Future<void> _onWeatherSearched(
    WeatherSearched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(networkStatus: NetworkStatus.loading));
    final failureOnWeather = await getForecastByName(
      GetForecastByNameParams(locationName: event.keyword),
    );
    failureOnWeather.fold((failure) {
      emit(
        state.copyWith(
          networkStatus: NetworkStatus.failure,
          message: failure.toMessage,
        ),
      );
    }, (weather) {
      if (state.units.isFahrenheit) {
        weather = Weather(
          condition: weather.condition,
          lastUpdated: weather.lastUpdated,
          location: weather.location,
          temperature: weather.temperature.toFahrenheit(),
        );
      }
      emit(
        state.copyWith(networkStatus: NetworkStatus.success, weather: weather),
      );
    });
  }

  Future<void> _onWeatherUnitChanged(
    WeatherUnitChanged event,
    Emitter<WeatherState> emit,
  ) async {
    Weather? weather = state.weather;
    if (weather != null) {
      if (state.units == event.units) return;
      if (event.units.isCelcius) {
        weather = Weather(
          condition: weather.condition,
          lastUpdated: weather.lastUpdated,
          location: weather.location,
          temperature: weather.temperature.toCelcius(),
        );
      } else {
        weather = Weather(
          condition: weather.condition,
          lastUpdated: weather.lastUpdated,
          location: weather.location,
          temperature: weather.temperature.toFahrenheit(),
        );
      }
    }
    emit(
      state.copyWith(
        units: event.units,
        weather: weather,
      ),
    );
  }
}

extension _FailureException on Failure {
  get toMessage {
    switch (runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}

extension on double {
  double toFahrenheit() => ((this * 9 / 5) + 32);
  double toCelcius() => ((this - 32) * 5 / 9);
}

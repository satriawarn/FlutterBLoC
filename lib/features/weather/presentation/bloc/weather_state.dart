part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final NetworkStatus networkStatus;
  final String message;
  final Weather? weather;
  final TemperatureUnits units;
  const WeatherState({
    this.networkStatus = NetworkStatus.init,
    this.message = '',
    this.units = TemperatureUnits.celcius,
    this.weather,
  });

  @override
  List<Object?> get props => [networkStatus, message, weather, units];

  WeatherState copyWith({
    NetworkStatus? networkStatus,
    String? message,
    Weather? weather,
    TemperatureUnits? units,
  }) {
    return WeatherState(
      networkStatus: networkStatus ?? this.networkStatus,
      message: message ?? this.message,
      weather: weather ?? this.weather,
      units: units ?? this.units,
    );
  }
}

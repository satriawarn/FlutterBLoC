import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/core/network/network_info.dart';
import 'package:flutter_state_bloc/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_local_data.dart';
import 'package:flutter_state_bloc/features/weather/data/sources/weather_remote_data.dart';
import 'package:flutter_state_bloc/features/weather/domain/repositories/weather_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final http.Client client = http.Client();
  final InternetConnectionChecker checker = InternetConnectionChecker();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(internetConnectionChecker: checker);
  final WeatherLocalDataSource weatherLocalDataSource =
      WeatherLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final WeatherRemoteDataSource weatherRemoteDataSource =
      WeatherRemoteDataImpl(client: client);
  final WeatherRepository weatherRepository = WeatherRepositoryImpl(
    localDataSource: weatherLocalDataSource,
    remoteDataSource: weatherRemoteDataSource,
    networkInfo: networkInfo,
  );
  runApp(
    MainApp(weatherRepository: weatherRepository),
  );
}

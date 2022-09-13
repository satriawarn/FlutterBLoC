import 'dart:convert';

import 'package:flutter_state_bloc/core/error/failures.dart';
import 'package:flutter_state_bloc/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class WeatherRemoteDataSource {
  Future<GeoCollectionModel> getGeoByKeyword(String keyword);
  Future<WeatherModel> getForecastByLatLong(double lat, double long);
}

class WeatherRemoteDataImpl implements WeatherRemoteDataSource {
  const WeatherRemoteDataImpl({
    required this.client,
  });
  final http.Client client;

  @override
  Future<WeatherModel> getForecastByLatLong(double lat, double long) async {
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&timezone=UTC&current_weather=true');
    final headers = {'Content-Type': 'application/json'};
    final response = await client.get(
      uri,
      headers: headers,
    );

    if (response.statusCode != 200) throw ServerException();

    return WeatherModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<GeoCollectionModel> getGeoByKeyword(String keyword) async {
    final uri = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$keyword&count=1');
    final headers = {'Content-Type': 'application/json'};
    final response = await client.get(uri, headers: headers);

    if (response.statusCode != 200) throw ServerException();

    return GeoCollectionModel.fromJson(jsonDecode(response.body));
  }
}

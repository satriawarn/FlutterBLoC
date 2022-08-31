import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_state_bloc/model/movie_response.dart';
import 'package:flutter_state_bloc/model/trailers_response.dart';

import '../model/cast_response.dart';
import '../model/genre_response.dart';
import '../model/movie.dart';
import '../model/movie_detail_response.dart';
import '../model/person_response.dart';
import '../utils/failure.dart';
import '../utils/logging.dart';

class MovieRepository {
  final String apiKey = "022836d378dd25e7d064b78034991927";
  static String baseUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  )..interceptors.add(Logging());

  var getUpComingApi = '$baseUrl/movie/upcoming';
  var getPopularMoviesApi = '$baseUrl/movie/popular';
  var getTopRatedMoviesApi = '$baseUrl/movie/top_rated';
  var getNowPlayingMoviesApi = '$baseUrl/movie/now_playing';
  var searchMovie = '$baseUrl/search/movie';

  var getMoviesApi = '$baseUrl/movie/top_rated';
  var getMoviesUrl = '$baseUrl/discover/movie';
  var getPlayingUrl = '$baseUrl/movie/now_playing';
  var getGenresUrl = "$baseUrl/genre/movie/list";
  var getPersonsUrl = "$baseUrl/trending/person/week";
  var movieUrl = "$baseUrl/movie";

  Future<MovieResponse> getMovies(int page) async {
    var params = {"api_key": apiKey, "language": "en-US", "page": page};
    try {
      Response respose = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(respose.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getPopuparMovies(int page) async {
    var params = {"api_key": apiKey, "language": "en-US", "page": page};
    try {
      Response response =
          await _dio.get(getPopularMoviesApi, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getSearchMovie(String query, int page) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "region": "ID",
      "page": page,
      "query": query,
    };
    try {
      Response response = await _dio.get(searchMovie, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getMoviesByIdGenre(String query, int page) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": page,
      "with_genres": query,
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getNowPlaying(int page) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": page,
      "region": "ID"
    };
    try {
      Response response =
          await _dio.get(getNowPlayingMoviesApi, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getUpcomingMovies() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
      "region": "ID"
    };
    try {
      Response response =
          await _dio.get(getUpComingApi, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getTopRatedMovies() async {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};
    try {
      Response response =
          await _dio.get(getTopRatedMoviesApi, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return GenreResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {"api_key": apiKey};
    try {
      Response response =
          await _dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return PersonResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  // Future<MovieResponse> getMovieByGenre(int id) async {
  //   var params = {
  //     "api_key": apiKey,
  //     "language": "en-US",
  //     "page": 1,
  //     "with_genres": id
  //   };
  //   try {
  //     Response response = await _dio.get(getMoviesUrl, queryParameters: params);
  //     return MovieResponse.fromJson(response.data);
  //   } catch (error, stacktrace) {
  //     return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
  //   }
  // }

  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response =
          await _dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieDetailResponse.withError(
          "Error: $error, StackTrace: $stacktrace");
    }
  }

  // Future<VideoResponse> getMovieVideos(int id) async {
  //   var params = {"api_key": apiKey, "language": "en-US"};
  //   try {
  //     Response response = await _dio.get(movieUrl + "/$id" + "/videos",
  //         queryParameters: params);
  //     return VideoResponse.fromJson(response.data);
  //   } catch (error, stacktrace) {
  //     return VideoResponse.withError("Error: $error, StackTrace: $stacktrace");
  //   }
  // }

  Future<MovieResponse> getSimilarMovies(int id) async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/similar",
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MovieResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response =
          await _dio.get("$movieUrl/$id/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CastResponse.withError("Error: $error, StackTrace: $stacktrace");
    }
  }

  Future<TrailersResponse> getTrailerMovie(int id) async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response =
          await _dio.get("$movieUrl/$id/videos", queryParameters: params);
      return TrailersResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return TrailersResponse.withError(
          "Error: $error, StackTrace: $stacktrace");
    }
  }
}

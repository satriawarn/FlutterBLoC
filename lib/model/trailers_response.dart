import 'trailers.dart';

class TrailersResponse {
  final List<Trailers> trailers;
  final String error;

  TrailersResponse(this.trailers, this.error);

  TrailersResponse.fromJson(Map<String, dynamic> json)
      : trailers =
            (json["results"] as List).map((e) => Trailers.fromJson(e)).toList(),
        error = "";

  TrailersResponse.withError(String errorValue)
      : trailers = [],
        error = errorValue;
}

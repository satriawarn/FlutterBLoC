import 'package:equatable/equatable.dart';

class Trailers extends Equatable {
  final String name;
  final String key;
  final String site;
  final String id;

  const Trailers(this.name, this.key, this.site, this.id);

  Trailers.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "",
        key = json["key"] ?? "",
        site = json["site"] ?? "",
        id = json["id"] ?? "";

  @override
  List<Object> get props => [name, key, site, id];

  static const empty = Trailers("", "", "", "");
}

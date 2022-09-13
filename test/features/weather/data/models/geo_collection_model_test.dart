import 'dart:convert';

import 'package:flutter_state_bloc/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_state_bloc/features/weather/data/models/geo_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  const tGeoModel = GeoModel(
    id: 1621177,
    name: "Yogyakarta",
    latitude: -7.80139,
    longitude: 110.36472,
    elevation: 110.0,
    featurCode: "PPLA",
    countryCode: "ID",
    timezone: "Asia/Jakarta",
    countryId: 1643084,
    country: "Indonesia",
  );

  const tGeoCollectionModel = GeoCollectionModel(
    results: [tGeoModel],
    generationtimeMs: 0.51796436,
  );

  const tEmptyGeoCollectionModel = GeoCollectionModel(
    generationtimeMs: 0.51796436,
    results: [],
  );

  group('GeoCollectionModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        final jsonMap = jsonDecode(fixture('geo_result.json'));

        final result = GeoCollectionModel.fromJson(jsonMap);

        expect(result, tGeoCollectionModel);
      });

      test('should return a valid model without results for empty', () async {
        final jsonMap = jsonDecode(fixture('geo_empty.json'));

        final result = GeoCollectionModel.fromJson(jsonMap);

        expect(result, tEmptyGeoCollectionModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        final result = tGeoCollectionModel.toJson();

        final expectedMap = {
          'results': [tGeoModel],
          'generationtime_ms': 0.51796436,
        };

        expect(result, expectedMap);
      });
    });
  });
}

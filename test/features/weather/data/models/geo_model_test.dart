import 'dart:convert';

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

  group('GeoModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        final jsonMap = jsonDecode(fixture('geo_only.json'));

        final result = GeoModel.fromJson(jsonMap);

        expect(result, tGeoModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        final result = tGeoModel.toJson();

        final expectedMap = {
          'id': 1621177,
          'name': "Yogyakarta",
          'latitude': -7.80139,
          'longitude': 110.36472,
          'elevation': 110.0,
          'feature_code': "PPLA",
          'country_code': "ID",
          'timezone': "Asia/Jakarta",
          'country_id': 1643084,
          'country': "Indonesia",
        };

        expect(result, expectedMap);
      });
    });
  });
}

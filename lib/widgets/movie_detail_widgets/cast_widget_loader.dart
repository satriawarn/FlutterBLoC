import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildCastslistLoaderWidget(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.black87,
    highlightColor: Colors.white54,
    enabled: true,
    child: Container(),
  );
}

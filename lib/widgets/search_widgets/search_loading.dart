import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/widgets/search_widgets/search_item_card.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSearchMovieLoaderWidget(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[850]!,
    highlightColor: Colors.white,
    enabled: true,
    child: AspectRatio(
      aspectRatio: 1 / 1,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        },
      ),
    ),
  );
}

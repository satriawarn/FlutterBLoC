import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_state_bloc/bloc/theme_bloc/theme_controller.dart';
import 'package:flutter_state_bloc/model/trailers.dart';
import 'package:flutter_state_bloc/repository/movie_repository.dart';
import 'package:flutter_state_bloc/utils/snack_bar.dart';
import 'package:flutter_state_bloc/widgets/movie_detail_widgets/video_player.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:meta/meta.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class TrailersListHorizontal extends StatelessWidget {
  const TrailersListHorizontal({
    Key? key,
    required this.trailers,
    required this.themeController,
    required this.movieRepository,
  }) : super(key: key);

  final List<Trailers> trailers;
  final ThemeController themeController;
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < trailers.length; i++)
                if (trailers[i].site == 'YouTube')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(
                              id: trailers[i].key,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.black87,
                                  highlightColor: Colors.white54,
                                  enabled: true,
                                  child: const SizedBox(
                                    height: 120.0,
                                    width: 200.0,
                                    child: AspectRatio(
                                      aspectRatio: 2 / 3,
                                      child: Icon(
                                        FontAwesome5.film,
                                        color: Colors.black26,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade900,
                                    boxShadow: kElevationToShadow[8],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.memoryNetwork(
                                      fit: BoxFit.cover,
                                      placeholderErrorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/img/trailer_placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/img/trailer_placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://img.youtube.com/vi/${trailers[i].key}/0.jpg',
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 3.0,
                                  left: 3.0,
                                  right: 3.0,
                                  top: 3.0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 200,
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              trailers[i].name,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

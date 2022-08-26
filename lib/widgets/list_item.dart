import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_state_bloc/model/movie.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text(
          '${movie.id}',
          style: textTheme.caption,
        ),
        title: Text(movie.title),
        isThreeLine: true,
        subtitle: Text(movie.popularity.toString()),
        dense: true,
      ),
    );
  }
}

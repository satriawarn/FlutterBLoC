part of 'genre_cubit.dart';

@immutable
abstract class GenreState extends Equatable {
  const GenreState();
}

class GenreInitial extends GenreState {
  @override
  List<Object> get props => [];
}

class GenreLoadInProgress extends GenreState {
  @override
  List<Object> get props => [];
}

class GenreLoadSuccess extends GenreState {
  const GenreLoadSuccess(this.genreMovieResult);

  final List<Movie> genreMovieResult;

  @override
  List<Object> get props => [genreMovieResult];
}

class GenreLoadFailure extends GenreState {
  @override
  List<Object> get props => [];
}

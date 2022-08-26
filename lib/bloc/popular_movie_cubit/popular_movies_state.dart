part of 'popular_movies_cubit.dart';

enum ListStatus { loading, success, failure }

class PopularMoviesState extends Equatable {
  const PopularMoviesState._({
    this.status = ListStatus.loading,
    this.movies = const <Movie>[],
  });

  const PopularMoviesState.loading() : this._();

  const PopularMoviesState.success(List<Movie> movies)
      : this._(status: ListStatus.success, movies: movies);

  const PopularMoviesState.failure() : this._(status: ListStatus.failure);

  final ListStatus status;
  final List<Movie> movies;

  @override
  List<Object> get props => [status, movies];
}

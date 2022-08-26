part of 'top_rated_movies_cubit.dart';

enum ListStatus { loading, success, failure }

class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState._({
    this.status = ListStatus.loading,
    this.movies = const <Movie>[],
  });

  const TopRatedMoviesState.loading() : this._();

  const TopRatedMoviesState.success(List<Movie> movies)
      : this._(status: ListStatus.success, movies: movies);

  const TopRatedMoviesState.failure() : this._(status: ListStatus.failure);

  final ListStatus status;
  final List<Movie> movies;

  @override
  List<Object> get props => [status, movies];
}

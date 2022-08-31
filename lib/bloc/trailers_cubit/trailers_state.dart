part of 'trailers_cubit.dart';

enum ListStatus { loading, success, failure }

class TrailersState extends Equatable {
  const TrailersState._({
    this.status = ListStatus.loading,
    this.trailers = const <Trailers>[],
  });

  const TrailersState.loading() : this._();

  const TrailersState.success(List<Trailers> trailers)
      : this._(status: ListStatus.success, trailers: trailers);

  const TrailersState.failure() : this._(status: ListStatus.failure);

  final ListStatus status;
  final List<Trailers> trailers;

  @override
  List<Object> get props => [status, trailers];
}

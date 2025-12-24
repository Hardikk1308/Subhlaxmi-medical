part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class PerformSearchEvent extends SearchEvent {
  final String query;
  const PerformSearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

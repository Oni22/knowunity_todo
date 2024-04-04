part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<TodoModel> todos;
  final bool isLoading;
  final bool isLoadingMore;
  final int start;
  final int limit;

  const HomeState._(
      {required this.todos,
      required this.isLoading,
      required this.start,
      required this.isLoadingMore,
      required this.limit});

  factory HomeState.initial() {
    return const HomeState._(
      todos: [],
      isLoading: false,
      isLoadingMore: false,
      start: 0,
      limit: 15,
    );
  }

  HomeState copyWith({
    List<TodoModel> Function()? todos,
    bool Function()? isLoading,
    bool Function()? isLoadingMore,
    int Function()? start,
    int Function()? limit,
  }) {
    return HomeState._(
      todos: todos?.call() ?? this.todos,
      isLoading: isLoading?.call() ?? this.isLoading,
      start: start?.call() ?? this.start,
      limit: limit?.call() ?? this.limit,
      isLoadingMore: isLoadingMore?.call() ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
        todos,
        isLoading,
        isLoadingMore,
        start,
        limit,
      ];
}

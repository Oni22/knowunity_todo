part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<TodoModel> todos;
  final bool isLoading;
  final bool isLoadingMore;
  final int start;
  final int limit;
  final int totalItems;
  final int completedItems;

  const HomeState._(
      {required this.todos,
      required this.isLoading,
      required this.start,
      required this.isLoadingMore,
      required this.totalItems,
      required this.completedItems,
      required this.limit});

  factory HomeState.initial() {
    return const HomeState._(
      todos: [],
      isLoading: false,
      isLoadingMore: false,
      start: 0,
      limit: 15,
      completedItems:
          90, // defaults to 90, since json placeholder has 90 completed items by default
      totalItems:
          200, // defaults to 200, since we don't have a total count in json placeholder response
    );
  }

  HomeState copyWith({
    List<TodoModel> Function()? todos,
    bool Function()? isLoading,
    bool Function()? isLoadingMore,
    int Function()? start,
    int Function()? limit,
    int Function()? totalItems,
    int Function()? completedItems,
  }) {
    return HomeState._(
      todos: todos?.call() ?? this.todos,
      isLoading: isLoading?.call() ?? this.isLoading,
      start: start?.call() ?? this.start,
      limit: limit?.call() ?? this.limit,
      isLoadingMore: isLoadingMore?.call() ?? this.isLoadingMore,
      totalItems: totalItems?.call() ?? this.totalItems,
      completedItems: completedItems?.call() ?? this.completedItems,
    );
  }

  @override
  List<Object> get props => [
        todos,
        isLoading,
        isLoadingMore,
        start,
        limit,
        totalItems,
        completedItems,
      ];
}

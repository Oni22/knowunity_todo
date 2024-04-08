part of 'home_cubit.dart';

enum Status { initial, loading, success, failure }

class HomeState extends Equatable {
  final List<TodoModel> todos;
  final bool isLoadingMore;
  final int start;
  final int limit;
  final int totalItems;
  final int completedItems;
  final CustomError? error;
  final Status status;

  const HomeState._(
      {required this.todos,
    required this.status,
      required this.start,
      required this.isLoadingMore,
      required this.totalItems,
      required this.completedItems,
    required this.limit,
    this.error,
  });

  factory HomeState.initial() {
    return const HomeState._(
      todos: [],
      status: Status.initial,
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
    Status Function()? status,
    bool Function()? isLoadingMore,
    int Function()? start,
    int Function()? limit,
    int Function()? totalItems,
    int Function()? completedItems,
    CustomError? Function()? error,
  }) {
    return HomeState._(
      todos: todos?.call() ?? this.todos,
      status: status?.call() ?? this.status,
      start: start?.call() ?? this.start,
      limit: limit?.call() ?? this.limit,
      isLoadingMore: isLoadingMore?.call() ?? this.isLoadingMore,
      totalItems: totalItems?.call() ?? this.totalItems,
      completedItems: completedItems?.call() ?? this.completedItems,
      error: error?.call() ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        todos,
        status,
        isLoadingMore,
        start,
        limit,
        totalItems,
        completedItems,
      ];
}

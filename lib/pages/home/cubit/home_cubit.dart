import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:knowunity_todo/api/api.dart';
import 'package:knowunity_todo/interfaces/error.dart';
import 'package:knowunity_todo/models/todo_model/todo_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());
  final api = useApi();
  var nextId = 200; // json placeholder default size
  

  Future<void> getTodos() async {
    try {
      emit(state.copyWith(status: () => Status.loading));
      final todos = await api.todo.get(start: state.start, limit: state.limit);
      emit(
        state.copyWith(
          todos: () => todos,
          status: () => Status.success,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          error: () => CustomError(
            message: err.toString(),
          ),
          status: () => Status.failure,
        ),
      );
    }
  }

  Future<void> loadMoreTodos() async {
    try {
      emit(
        state.copyWith(
          isLoadingMore: () => true,
          isLoadingMoreError: () => false,
        ),
      );
      final startAt = state.start + state.limit;
      final todos = await api.todo.get(start: startAt, limit: state.limit);
      emit(state.copyWith(
          todos: () => [...state.todos, ...todos],
          isLoadingMore: () => false,
            start: () => startAt),
      );
    } catch (err) {
      emit(
        state.copyWith(
          error: () => CustomError(
            message: err.toString(),
          ),
            isLoadingMore: () => false,
            isLoadingMoreError: () => true
        ),
      );

    }
  }

  void addTodo(String title) {
    // we mock the user id since we don't have a user system
    // we also mock the id since we don't have a post endpoint for todos
    final todo = TodoModel(
      userId: 1,
      id: nextId++, // we increment the id based on the default from json placeholder (200) to make it unique
      title: title,
      completed: false,
    );
    emit(
      state.copyWith(
        todos: () => [todo, ...state.todos],
        totalItems: () => state.totalItems + 1,
      ),
    );
  }

  void toggleTodo(int id, bool value) {
    final index = state.todos.indexWhere((e) => e.id == id);
    final todo = state.todos[index];
    final newTodos = List<TodoModel>.from(state.todos);
    newTodos[index] = TodoModel(
      userId: todo.userId,
      id: todo.id,
      title: todo.title,
      completed: value,
    );
    final completedItems = state.completedItems + (value ? 1 : -1);
    emit(
      state.copyWith(
        todos: () => newTodos,
        completedItems: () => completedItems,
      ),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:knowunity_todo/api/api.dart';
import 'package:knowunity_todo/models/todo_model/todo_model.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());
  final api = useApi();

  Future<List<TodoModel>> _fetchTodos(int start, int limit) async {
    return await api.todo.get(start, limit);
  }

  Future<void> getTodos() async {
    try {
      final todos = await _fetchTodos(state.start, state.limit);
      emit(state.copyWith(todos: () => todos, isLoading: () => false));
    } catch (err) {
      // add error handling
    }
  }

  Future<void> loadMoreTodos() async {
    try {
      emit(state.copyWith(isLoadingMore: () => true));
      final newLimit = state.start + state.limit;
      final todos = await _fetchTodos(newLimit, state.limit);
      emit(state.copyWith(
          todos: () => [...state.todos, ...todos],
          isLoadingMore: () => false,
          start: () => newLimit));
    } catch (err) {
      // add error handling
    }
  }

  void addTodo(String title) {
    // we mock the user id since we don't have a user system
    // we also mock the id since we don't have a post endpoint
    final todo = TodoModel(
      userId: 1,
      id: state.todos.length + 1,
      title: title,
      completed: false,
    );
    emit(state.copyWith(todos: () => [todo, ...state.todos]));
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
    emit(state.copyWith(todos: () => newTodos));
  }
}

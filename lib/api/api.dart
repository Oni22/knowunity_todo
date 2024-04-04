import 'package:dio/dio.dart';
import 'package:knowunity_todo/services/todo_service.dart';

class API {
  API._();
  static final instance = API._();

  late final TodoService todo;

  initialize({required String baseUrl}) {
    // setup dio instance
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    // Add more services here
    todo = TodoService(dio);
  }
}

// Returns a singleton instance of the API
API useApi() {
  return API.instance;
}

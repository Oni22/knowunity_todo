import 'package:dio/dio.dart';
import 'package:knowunity_todo/models/todo_model/todo_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'todo_service.g.dart';

@RestApi(baseUrl: "/todos")
abstract class TodoService {
  factory TodoService(Dio dio, {String baseUrl}) = _TodoService;

  @GET("/")
  Future<List<TodoModel>> get(
  {
    @Query("_start") int? start,
    @Query("_limit") int? limit,
  }
  );

  @GET("/{id}")
  Future<List<TodoModel>> getById(@Path() int id);

  @POST("/")
  Future<List<TodoModel>> create(@Body() TodoModel todo);
}

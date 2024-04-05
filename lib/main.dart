import 'package:flutter/material.dart';
import 'package:knowunity_todo/api/api.dart';
import 'package:knowunity_todo/pages/home/widgets/home_page.dart';
import 'package:knowunity_todo/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final api = useApi();
  api.initialize(baseUrl: "https://jsonplaceholder.typicode.com");

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knowunity Todo',
      theme: theme,
      home: const HomePage(),
    );
  }
}

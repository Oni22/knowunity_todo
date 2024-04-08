import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowunity_todo/pages/home/cubit/home_cubit.dart';
import 'package:knowunity_todo/pages/home/utils/progress_header_delegate.dart';
import 'package:knowunity_todo/pages/home/widgets/add_todo_form.dart';
import 'package:knowunity_todo/pages/home/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  final controller = ScrollController();
  late ConfettiController _controllerCenter;
  bool switchTitle = false;
  Timer? debouncer;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    homeCubit = HomeCubit();
    homeCubit.getTodos();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debouncer?.cancel();
        debouncer = Timer(const Duration(milliseconds: 200), () {
          print("LOAD MORE!");
          homeCubit.loadMoreTodos();
        });
      }

      // we only want to switch the title when the user scrolls
      // we seperated this from the bloc because it's a UI concern
      // Optimization: We could build a seperated widget for this to prevent state update for the whole page
      if (controller.position.pixels > 50 && !switchTitle) {
        setState(() {
          switchTitle = true;
        });
      } else if (controller.position.pixels < 50 && switchTitle) {
        setState(() {
          switchTitle = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
              bloc: homeCubit,
              builder: (context, state) {
                return CustomScrollView(
                  controller: controller,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.blue,
                      pinned: true,
                      title: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        firstChild: const Text(
                          "Hey there! 🎉",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        secondChild: const Text(
                          "Let's get those todos! 🚀",
                        ),
                        crossFadeState: controller.hasClients &&
                                controller.position.pixels > 50
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.purple],
                          ),
                        ),
                        child: const FlexibleSpaceBar(
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                "Ready to slay your to-do list with style?",
                                style: TextStyle(),
                              ),
                              Text(
                                  "Let's turn those goals into 'done and dusted'")
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: AddTodoForm(
                                      onSubmit: (title) {
                                        homeCubit.addTodo(title);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        )
                      ],
                      expandedHeight: 200,
                    ),
                  
                  if (state.status == Status.loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (state.status == Status.failure)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.error != null
                                ? state.error!.message
                                : "Oops! Something went wrong."),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                homeCubit.getTodos();
                              },
                              child: const Text("Retry"),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (state.status == Status.success && state.todos.isNotEmpty)
                    if (state.status == Status.success &&
                        state.todos.isNotEmpty)
                    SliverPersistentHeader(
                      delegate: ProgessHeaderDelegate(
                        progress: (state.completedItems / state.totalItems),
                      ),
                      pinned: true,
                    ),
                  if (state.status == Status.success && state.todos.isNotEmpty)
                    SliverList.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return TodoItem(
                          title: "${todo.id} - ${todo.title}",
                          completed: todo.completed,
                          onToggle: (value) {
                            handleTodoStatus(todo.id, value);
                          },
                        );
                      },
                    ),

                    SliverSafeArea(
                      minimum: const EdgeInsets.only(bottom: 100),
                      sliver: SliverToBoxAdapter(
                        child: state.isLoadingMore
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox(),
                      ),
                    )
                  ],
                );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              numberOfParticles: 30,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }

  void handleTodoStatus(int id, bool value) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                  text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Are you sure you want to mark this task as ',
                  ),
                  TextSpan(
                    text: '${value ? "completed" : "open"}?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    key: const Key("alert-btn-yes"),
                    onPressed: () {
                      homeCubit.toggleTodo(id, value);
                      if (value) {
                        _controllerCenter.play();
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                  ),
                  ElevatedButton(
                    key: const Key("alert-btn-no"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

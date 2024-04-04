import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowunity_todo/pages/home/cubit/home_cubit.dart';
import 'package:knowunity_todo/pages/home/widgets/add_todo_form.dart';
import 'package:knowunity_todo/pages/home/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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
                    SliverList.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return TodoItem(
                          title: "${todo.id} - ${todo.title}",
                          completed: todo.completed,
                          onToggle: (value) {
                            homeCubit.toggleTodo(todo.id, value);
                            if (value) {
                              _controllerCenter.play();
                            }
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
              }),
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
}

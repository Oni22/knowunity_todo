import 'package:flutter/material.dart';

class AddTodoForm extends StatefulWidget {
  final void Function(String)? onSubmit;

  const AddTodoForm({super.key, this.onSubmit});

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Next Task ✍️",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "What's the next big thing? Type it out, and let's make it happen. No pressure, just progress.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: titleTextController,
              decoration: const InputDecoration(
                hintText: "Count your chickens before they hatch 🐣",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                child: const Text("Add Todo"),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit?.call(titleTextController.text);
    }
  }
}

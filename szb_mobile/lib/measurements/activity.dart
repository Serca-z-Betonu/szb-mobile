import 'package:flutter/material.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Text("Dodaj aktywność:"),
        TextField(controller: controller)
      ],
    ));
  }
}

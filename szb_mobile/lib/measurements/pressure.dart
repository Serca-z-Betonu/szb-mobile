import 'package:flutter/material.dart';

class AddPressure extends StatefulWidget {
  const AddPressure({super.key});

  @override
  State<AddPressure> createState() => _AddPressureState();
}

class _AddPressureState extends State<AddPressure> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Text("Dodaj pomiar ciśnienia:"),
        TextField(controller: controller)
      ],
    ));
  }
}

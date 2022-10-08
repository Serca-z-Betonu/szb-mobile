import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:szb_mobile/measurements/measurements_view.dart';

part 'pressure.g.dart';

@JsonSerializable()
class Pressure {
  final int low;
  final int high;
  final DateTime time;

  Pressure(this.low, this.high, this.time);

  factory Pressure.fromJson(Map<String, dynamic> json) =>
      _$PressureFromJson(json);
  Map<String, dynamic> toJson() => _$PressureToJson(this);
}

class PressureRow extends StatelessWidget {
  final Pressure pressure;

  const PressureRow(this.pressure, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(pressure.time.toIso8601String()),
          Text("${pressure.high} / ${pressure.low} Hgmm")
        ],
      ),
    );
  }
}

class Pressures extends StatelessWidget {
  const Pressures({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementsView(PressureRow.new, (_) => const AddPressure());
  }
}

class AddPressure extends StatefulWidget {
  const AddPressure({super.key});

  @override
  State<AddPressure> createState() => _AddPressureState();
}

class _AddPressureState extends State<AddPressure> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
          title: const Text("Dodaj pomiar ciśnienia"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("cancel")),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final low = int.parse(controller.text);
                    Navigator.pop(context, Pressure(low, low, DateTime.now()));
                  }
                },
                child: const Text("add"))
          ],
          content: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value == "") {
                  return "Należy wypełnić";
                }
                return null;
              })),
    );
  }
}

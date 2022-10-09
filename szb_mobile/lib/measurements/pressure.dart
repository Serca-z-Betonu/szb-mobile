import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:szb_mobile/measurements/measurements_view.dart';
import "package:http/http.dart" as http;

part 'pressure.g.dart';

@JsonSerializable()
class Pressure {
  final double low;
  final double high;
  final DateTime time;

  Pressure(this.low, this.high, this.time);

  factory Pressure.fromJson(Map<String, dynamic> json) =>
      _$PressureFromJson(json);
  Map<String, dynamic> toJson() => _$PressureToJson(this);
}

Future<List<Pressure>> getPressureList() async {
  final reses = await Future.wait([
    http.get(Uri.http("192.168.14.8:8090", "/metrics",
        {"patient_id": "3", "metric_type": "BLOOD_PRESSURE_MAX"})),
    http.get(Uri.http("192.168.14.8:8090", "/metrics",
        {"patient_id": "3", "metric_type": "BLOOD_PRESSURE_MIN"}))
  ]);

  final highs = jsonDecode(reses[0].body)["samples"].toList();
  final lows = jsonDecode(reses[1].body)["samples"].toList();

  final combined = <Pressure>[];
  for (var i = 0; i < highs.length; ++i) {
    combined.add(Pressure(lows[i]["value"], highs[i]["value"],
        DateTime.parse(highs[i]["timestamp"])));
  }

  return combined.reversed.toList();
}

class PressureRow extends StatelessWidget {
  final Pressure pressure;

  const PressureRow(this.pressure, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          constraints: const BoxConstraints(
              maxHeight: double.infinity,
              minHeight: 0,
              maxWidth: 300,
              minWidth: 300),
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat("MMM d, H:m", "pl").format(pressure.time),
              ),
              Text(
                "${pressure.high} / ${pressure.low} Hgmm",
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Pressures extends StatelessWidget {
  const Pressures({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementsView<Pressure>(PressureRow.new,
        (_) => const AddPressure(), "Ciśnienie", getPressureList);
  }
}

class AddPressure extends StatefulWidget {
  const AddPressure({super.key});

  @override
  State<AddPressure> createState() => _AddPressureState();
}

class _AddPressureState extends State<AddPressure> {
  final _highController = TextEditingController();
  final _lowController = TextEditingController();
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
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final low = int.parse(_lowController.text).toDouble();
                    final high = int.parse(_highController.text).toDouble();
                    final pressure = Pressure(low, high, DateTime.now());
                    http
                        .post(
                            Uri.http("192.168.14.8:8090", "/metrics",
                                {"patient_id": "3"}),
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode([
                              {
                                "metric_type": "BLOOD_PRESSURE_MIN",
                                "value": low,
                                "timestamp": pressure.time.toIso8601String()
                              }
                            ]))
                        .then((res) => print(res.body.toString()));
                    http
                        .post(
                            Uri.http("192.168.14.8:8090", "/metrics",
                                {"patient_id": "3"}),
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode([
                              {
                                "metric_type": "BLOOD_PRESSURE_MAX",
                                "value": high,
                                "timestamp": pressure.time.toIso8601String()
                              }
                            ]))
                        .then((res) => print(res.body.toString()));
                    Navigator.pop(context, pressure);
                  }
                },
                child: const Text("add"))
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  controller: _highController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Niskie',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Należy wypełnić";
                    }
                    return null;
                  }),
              const SizedBox(height: 15),
              TextFormField(
                  controller: _lowController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Wysokie',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Należy wypełnić";
                    }
                    return null;
                  })
            ],
          )),
    );
  }
}

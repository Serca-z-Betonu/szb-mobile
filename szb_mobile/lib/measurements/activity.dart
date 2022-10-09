import 'dart:convert';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:szb_mobile/measurements/measurements_view.dart';
import "package:http/http.dart" as http;

part 'activity.g.dart';

@JsonSerializable()
class Activity {
  @JsonKey(name: "description")
  final String name;
  @JsonKey(name: "end_timestamp")
  final DateTime time;
  @JsonKey(name: "duration_us")
  final Duration duration;

  const Activity(this.name, this.time, this.duration);

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

Future<List<Activity>> getActivityList() async {
  final res = await http
      .get(Uri.http("192.168.14.8:8090", "/activities", {"patient_id": "3"}));
  return List<Activity>.from(jsonDecode(utf8.decode(res.bodyBytes))
      .map((act) => Activity.fromJson(act))).reversed.toList();
}

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementsView<Activity>(ActivityRow.new,
        (_) => const AddActivity(), "Aktywność", getActivityList);
  }
}

class ActivityRow extends StatelessWidget {
  final Activity activity;

  const ActivityRow(this.activity, {super.key});

  static String formatDuration(Duration duration) {
    final hours = duration.inHours == 0 ? "" : "${duration.inHours}h ";
    final minutes = duration.inMinutes == 0
        ? ""
        : "${duration.inMinutes.remainder(60)} min";
    return hours + minutes;
  }

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
                DateFormat("MMM d, H:m", "pl").format(activity.time),
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "${activity.name}: ",
                    style: const TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    formatDuration(activity.duration),
                    style: const TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  String _name = "";
  Duration _duration = Duration.zero;
  final _formKey = GlobalKey<FormState>();

  void add() {
    if (_formKey.currentState!.validate()) {
      final activity = Activity(_name, DateTime.now(), _duration);
      http
          .post(
              Uri.http("192.168.14.8:8090", "/activities", {"patient_id": "3"}),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(activity.toJson()))
          .then((res) => print(res.body.toString()));
      Navigator.pop(context, activity);
    }
  }

  void setName(String name) => setState(() => _name = name);
  void setDuration(Duration duration) => setState(() => _duration = duration);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: AlertDialog(
          title: const Text("Dodaj aktywność:"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              onChanged: setName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nazwa',
              ),
              validator: (value) {
                if (value == null || value == "") {
                  return "Należy wypełnić";
                }
                return null;
              },
            ),
            FormField<Duration>(
              builder: (formFieldState) => Flexible(
                  child: SingleChildScrollView(
                      child: DurationPicker(
                onChange: (value) {
                  setDuration(value);
                  formFieldState.didChange(value);
                },
                duration: _duration,
              ))),
              validator: (duration) {
                if (duration == null ||
                    duration.compareTo(Duration.zero) == 0) {
                  return "Duration must be positive";
                }
                return null;
              },
            )
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("cancel")),
            ElevatedButton(onPressed: add, child: const Text("add"))
          ],
        ));
  }
}

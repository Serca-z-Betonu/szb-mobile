import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:szb_mobile/measurements/measurements_view.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
  final String name;
  final DateTime time;
  final Duration duration;

  const Activity(this.name, this.time, this.duration);

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementsView<Activity>(
        ActivityRow.new, (_) => const AddActivity());
  }
}

class ActivityRow extends StatelessWidget {
  final Activity activity;

  const ActivityRow(this.activity, {super.key});

  static String formatDuration(Duration duration) {
    final hours = duration.inHours == 0 ? "" : "${duration.inHours}h ";
    final minutes = duration.inMinutes == 0 ? "" : "${duration.inMinutes} min";
    return hours + minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(activity.time.toIso8601String()),
          Text("${activity.name}: ${formatDuration(activity.duration)}")
        ],
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
      Navigator.pop(context, Activity(_name, DateTime.now(), _duration));
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
          content: Column(children: [
            TextFormField(
              onChanged: setName,
              validator: (value) {
                if (value == null || value == "") {
                  return "Należy wypełnić";
                }
                return null;
              },
            ),
            FormField<Duration>(
              builder: (formFieldState) => DurationPicker(
                onChange: (value) {
                  setDuration(value);
                  formFieldState.didChange(value);
                },
                duration: _duration,
              ),
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
            TextButton(onPressed: add, child: const Text("add"))
          ],
        ));
  }
}

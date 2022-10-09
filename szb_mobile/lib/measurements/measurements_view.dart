import 'package:flutter/material.dart';

class MeasurementsView<T> extends StatefulWidget {
  final Widget Function(T row) rowBuilder;
  final Widget Function(BuildContext context) adderBuilder;
  final Future<List<T>> Function() fetch;
  final String title;

  const MeasurementsView(
      this.rowBuilder, this.adderBuilder, this.title, this.fetch,
      {super.key});

  @override
  State<MeasurementsView<T>> createState() => _MeasurementsViewState<T>();
}

class _MeasurementsViewState<T> extends State<MeasurementsView<T>> {
  final _scrollController = ScrollController();
  List<T>? measurements;

  void addMeasurement(T measurement) {
    print("adddinggg");
    setState(() => measurements = [measurement, ...measurements!]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<T>>(
        future: widget.fetch(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Text("data");
          } else {
            measurements ??= snapshot.data;
            return ListView(
              controller: _scrollController,
              shrinkWrap: true,
              reverse: true,
              children: measurements!.map(widget.rowBuilder).toList(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final measurement = await showDialog<T>(
              context: context, builder: widget.adderBuilder);
          if (measurement != null) {
            addMeasurement(measurement);
            _scrollController.animateTo(0.0,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          }
        },
      ),
    );
  }
}

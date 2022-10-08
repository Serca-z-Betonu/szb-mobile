import 'package:flutter/material.dart';

class MeasurementsView<T> extends StatefulWidget {
  final Widget Function(T row) rowBuilder;
  final Widget Function(BuildContext context) adderBuilder;

  const MeasurementsView(this.rowBuilder, this.adderBuilder, {super.key});

  @override
  State<MeasurementsView<T>> createState() => _MeasurementsViewState<T>();
}

class _MeasurementsViewState<T> extends State<MeasurementsView<T>> {
  final _scrollController = ScrollController();

  var measurements = <T>[];

  void addMeasurement(T measurement) {
    setState(() => measurements.add(measurement));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        reverse: true,
        children: measurements.map(widget.rowBuilder).toList(),
      ),
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

import 'package:flutter/material.dart';
import 'package:szb_mobile/measurements/activity.dart';
import 'package:szb_mobile/measurements/pressure.dart';
import 'package:szb_mobile/medicine/list.dart';

class Home extends StatelessWidget {
  static final routes = [
    NamedRoute("Ciśnienie", (_) => const AddPressure()),
    NamedRoute("Aktynwość", (_) => const AddActivity()),
    NamedRoute("Leki", (_) => const MedicineList()),
  ];

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 400 ? 4 : 3,
            children: routes
                .map((route) => GestureDetector(
                      onTap: () => route.pushWith(context),
                      child: Card(
                        child: Text(route.name),
                      ),
                    ))
                .toList()));
  }
}

class NamedRoute {
  final String name;
  final Widget Function(BuildContext) builder;

  const NamedRoute(this.name, this.builder);

  Future<T?> pushWith<T extends Object?>(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}

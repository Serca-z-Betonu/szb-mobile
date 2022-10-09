import 'package:flutter/material.dart';
import 'package:szb_mobile/measurements/activity.dart';
import 'package:szb_mobile/measurements/pressure.dart';
import 'package:szb_mobile/medicine/list.dart';

class Home extends StatelessWidget {
  static final routes = [
    NamedRoute("Ciśnienie", Icons.speed_rounded, (_) => const Pressures()),
    NamedRoute(
        "Aktywność", Icons.directions_run_rounded, (_) => const Activities()),
    NamedRoute("Leki", Icons.medication, (_) => const MedicineList()),
  ];

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/szb-logo-teal.png"),
          ),
          title: const Text("Pt. Dashboard"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(500, double.infinity)),
            child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: MediaQuery.of(context).size.width > 450 ? 3 : 2,
                children: routes
                    .map((route) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xff64d5bf), width: 2),
                            backgroundColor: Colors.white70,
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(fontSize: 21),
                          ),
                          onPressed: () => route.pushWith(context),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(route.icon, size: 60),
                                Text(route.name)
                              ]),
                        ))
                    .toList()),
          ),
        ));
  }
}

class NamedRoute {
  final String name;
  final IconData icon;
  final Widget Function(BuildContext) builder;

  const NamedRoute(this.name, this.icon, this.builder);

  Future<T?> pushWith<T extends Object?>(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}

import 'package:flutter/material.dart';
import 'package:szb_mobile/medicine/dose.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

Future<List<Dose>> getMedicineList() async {
  final res = await http.get(
      Uri.http("192.168.14.8:8090", "/prescriptions", {"patient_id": "3"}));
  return List<Dose>.from(
      jsonDecode(res.body).map((dose) => Dose.fromJson(dose)));
}

class MedicineList extends StatelessWidget {
  const MedicineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Leki"),
        ),
        body: FutureBuilder<List<Dose>>(
          future: getMedicineList(),
          builder: (context, snapshot) => snapshot.data == null
              ? const Text("data")
              : AnimatedList(
                  initialItemCount: snapshot.data!.length,
                  itemBuilder: ((context, index, _) =>
                      DoseRow(key: UniqueKey(), snapshot.data![index], () {
                        final drug = snapshot.data!.removeAt(index);
                        AnimatedList.of(context).removeItem(index,
                            (context, animation) {
                          final curved = CurvedAnimation(
                              parent: animation, curve: Curves.ease);
                          return FadeTransition(
                              opacity: curved,
                              child: SizeTransition(
                                  axis: Axis.vertical,
                                  sizeFactor: curved,
                                  child: DoneDoseRow(drug)));
                        });
                      })),
                ),
        ));
  }
}

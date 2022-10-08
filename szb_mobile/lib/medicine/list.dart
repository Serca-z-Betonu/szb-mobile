import 'package:flutter/material.dart';
import 'package:szb_mobile/medicine/dose.dart';

class MedicineList extends StatelessWidget {
  const MedicineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        for (var i = 0; i < 100; ++i) const DoseRow(Dose("SomLek", 30))
      ],
    ));
  }
}

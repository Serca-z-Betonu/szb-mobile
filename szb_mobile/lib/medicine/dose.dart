import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dose.g.dart';

@JsonSerializable()
class Dose {
  @JsonKey(name: "drug_name")
  final String name;
  @JsonKey(name: "expected_daily_dosage")
  final double amount;

  const Dose(this.name, this.amount);

  factory Dose.fromJson(Map<String, dynamic> json) => _$DoseFromJson(json);
  Map<String, dynamic> toJson() => _$DoseToJson(this);

  @override
  String toString() {
    return "$name: $amount mg";
  }
}

class DoseRow extends StatelessWidget {
  final Dose dose;
  final void Function() remove;

  const DoseRow(this.dose, this.remove, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 200,
              child: Text(
                dose.toString(),
                style: const TextStyle(fontSize: 20),
              )),
          TakenButton(remove)
        ],
      ),
    );
  }
}

class DoneDoseRow extends StatelessWidget {
  final Dose dose;

  const DoneDoseRow(this.dose, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 200,
              child: Text(
                dose.toString(),
                style: const TextStyle(fontSize: 20),
              )),
          Container(
              alignment: Alignment.center,
              height: 30,
              width: 80,
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}

class TakenButton extends StatefulWidget {
  final void Function() remove;

  const TakenButton(this.remove, {super.key});

  @override
  State<TakenButton> createState() => _TakenButtonState();
}

class _TakenButtonState extends State<TakenButton> {
  var showHeart = false;

  void onButtonAnimationEnd() {
    setState(() => showHeart = true);
  }

  void onHeartAnimationEnd() {
    widget.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 30,
        width: 80,
        child: showHeart
            ? Heart(onHeartAnimationEnd)
            : TakenButtonBody(onButtonAnimationEnd));
  }
}

class TakenButtonBody extends StatefulWidget {
  final void Function() onEnd;

  const TakenButtonBody(this.onEnd, {super.key});

  @override
  State<TakenButtonBody> createState() => _TakenButtonBodyState();
}

class _TakenButtonBodyState extends State<TakenButtonBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> height, width, opacity, scale;
  bool animating = false;

  void start() {
    if (!animating) {
      animating = true;
      _controller.forward().then((_) => widget.onEnd());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    height = Tween(begin: 30.0, end: 12.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.ease)));
    width = Tween(begin: 80.0, end: 12.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.ease)));
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.ease)));
    scale = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.9, 1, curve: Curves.ease)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
            scale: scale.value,
            child: ElevatedButton(
              onPressed: start,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 0),
                  fixedSize: Size(width.value, height.value),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              child: Opacity(
                opacity: opacity.value,
                child: const Text("Wzięte!"),
              ),
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Heart extends StatefulWidget {
  final void Function() onEnd;

  const Heart(this.onEnd, {super.key});

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..forward().then((_) => widget.onEnd());

    scale = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
            scale: scale.value,
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class MyAnimatedSwitcher extends StatefulWidget {
  final bool value;
  final Widget firstChild;
  final Widget secondChild;
  final Axis direction;
  final double axisAlignment;
  final EdgeInsetsGeometry? padding;

  const MyAnimatedSwitcher({
    Key? key,
    required this.value,
    required this.firstChild,
    required this.secondChild,
    this.direction = Axis.vertical,
    this.axisAlignment = 1.0,
    this.padding,
  }) : super(key: key);

  @override
  State<MyAnimatedSwitcher> createState() => _MyAnimatedSwitcherState();
}

class _MyAnimatedSwitcherState extends State<MyAnimatedSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => SizeTransition(
          axis: widget.direction, axisAlignment: widget.axisAlignment, sizeFactor: animation, child: child),
      child: widget.value ? widget.firstChild : widget.secondChild,
    );
  }
}

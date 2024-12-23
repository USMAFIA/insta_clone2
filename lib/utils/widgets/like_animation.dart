import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  bool isAnimating;
  VoidCallback? End;
  bool iconlike;
  LikeAnimation(
      {super.key,required this.child,required this.isAnimating, this.End, required this.iconlike,});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:widget.iconlike ? 200 : 400,
      ),
    );
    scale = Tween<double>(begin: 1, end: 1).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startanimation();
    }
  }

  void startanimation() async {
    if (widget.isAnimating || widget.iconlike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(microseconds: 200));
    }
    if (widget.End != null) {
      widget.End!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}

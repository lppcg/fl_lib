import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeIn({
    super.key,
    required this.child,
    this.duration = Durations.medium2,
  });

  @override
  State<FadeIn> createState() => _MyFadeInState();
}

class _MyFadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final _animation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.status != AnimationStatus.completed) {
      _controller.forward();
    }
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

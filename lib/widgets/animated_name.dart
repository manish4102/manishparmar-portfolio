// widgets/animated_name.dart
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedName extends StatefulWidget {
  const AnimatedName({super.key});

  @override
  State<AnimatedName> createState() => _AnimatedNameState();
}

class _AnimatedNameState extends State<AnimatedName> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;
  final String name = "MANISH";

  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startScatterAnimation();
  }

  void _setupAnimations() {
    _controllers = List.generate(name.length, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 1800),
        vsync: this,
      );
    });

    final rand = Random();
    _animations = List.generate(name.length, (i) {
      final startX = (rand.nextDouble() - 0.5) * 4;
      final startY = (rand.nextDouble() - 0.5) * 4;

      return Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: Curves.easeOutBack,
        ),
      );
    });
  }

  Future<void> _startScatterAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _controllers[i].forward();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _animationCompleted = true;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add home navigation logic here
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(name.length, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              return Transform.translate(
                offset: _animations[i].value * 100,
                child: Text(
                  name[i],
                  style: TextStyle(
                    fontSize: _animationCompleted ? 24 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

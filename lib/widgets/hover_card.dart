// placed_card.dart
import 'package:flutter/material.dart';

/// Same API/behavior as your old _PlacedCard (width, height, dx, dy, angle, child),
/// with hover/press animations layered on top.
class PlacedCard extends StatefulWidget {
  const PlacedCard({
    super.key,
    required this.width,
    required this.height,
    required this.dx,
    required this.dy,
    required this.angle,
    required this.child,

    // Optional extras
    this.includeTitleSpace = false,
    this.titleExtra = 56.0,

    // Hover tuning
    this.hoverScale = 1.04,
    this.hoverLift = 10.0,
    this.hoverRotate = 0.03, // ~1.7°
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,

    // Shadows
    this.baseShadows = const [
      BoxShadow(
        color: Color(0x26000000), // 15%
        blurRadius: 16,
        offset: Offset(0, 8),
        spreadRadius: -4,
      ),
    ],
    this.hoverShadows = const [
      BoxShadow(
        color: Color(0x30000000), // ~19%
        blurRadius: 28,
        offset: Offset(0, 14),
        spreadRadius: -6,
      ),
    ],
  });

  final double width;
  final double height;
  final double dx; // +right / -left
  final double dy; // +down  / -up
  final double angle; // radians
  final Widget child;

  final bool includeTitleSpace;
  final double titleExtra;

  final double hoverScale;
  final double hoverLift;
  final double hoverRotate;
  final Duration duration;
  final Curve curve;

  final List<BoxShadow> baseShadows;
  final List<BoxShadow> hoverShadows;

  @override
  State<PlacedCard> createState() => _PlacedCardState();
}

class _PlacedCardState extends State<PlacedCard> {
  bool _hover = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    final active = _hover || _press;

    // Same base transforms as before, with hover deltas added
    final transform = Matrix4.identity()
      ..translate(widget.dx, widget.dy - (active ? widget.hoverLift : 0.0))
      ..rotateZ(widget.angle + (active ? widget.hoverRotate : 0.0))
      ..scale(active ? widget.hoverScale : 1.0);

    final totalHeight =
        widget.height + (widget.includeTitleSpace ? widget.titleExtra : 0.0);

    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      transformAlignment: Alignment.center,
      transform: transform,
      decoration: BoxDecoration(
        boxShadow: active ? widget.hoverShadows : widget.baseShadows,
      ),
      // keep size identical to your old card box
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit:  (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, // mobile press feedback
          onTapDown: (_) => setState(() => _press = true),
          onTapUp:   (_) => setState(() => _press = false),
          onTapCancel: () => setState(() => _press = false),
          child: SizedBox(
            width: widget.width,
            height: totalHeight,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

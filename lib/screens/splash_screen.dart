import 'dart:math' as math;
import 'package:flutter/material.dart';
import '/widgets/nav_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _contentAnimationController;
  late AnimationController _slideUpController;
  late Animation<Offset> _slideUpAnimation;
  late List<AnimationController> _letterControllers;
  late List<Animation<Offset>> _letterAnimations;
  late Animation<double> _fadeAnimation;

  bool _showContent = false;
  bool _nameAnimationComplete = false;

  // NEW: control loader visibility
  bool _showLoader = false;

  final String name = "MANISH";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startNameAnimation();
  }

  void _initializeAnimations() {
    _contentAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideUpController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideUpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _slideUpController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeInOut,
    ));

    _letterControllers = List.generate(
      name.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      ),
    );

    _letterAnimations = _letterControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(
          (math.Random().nextDouble() - 0.5) * 4,
          (math.Random().nextDouble() - 0.5) * 4,
        ),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();
  }

  Future<void> _startNameAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));

    // Stagger letters in
    for (int i = 0; i < _letterControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      _letterControllers[i].forward();
    }

    // Give the elastic a beat to settle
    await Future.delayed(Duration(milliseconds: 600));

    setState(() {
      _nameAnimationComplete = true;
      _showLoader = true; // show the loader now
    });

    // Keep loader visible ~5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Hide loader and proceed with your existing content/fade/slide
    if (!mounted) return;
    setState(() {
      _showLoader = false;
      _showContent = true;
    });

    _contentAnimationController.forward();
    await Future.delayed(Duration(milliseconds: 1000));

    await _slideUpController.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 0),
        pageBuilder: (_, __, ___) => NavBar(),
      ),
    );
  }

  @override
  void dispose() {
    _contentAnimationController.dispose();
    _slideUpController.dispose();
    for (final c in _letterControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _slideUpAnimation,
        child: Stack(
          children: [
            if (_showContent) Container(color: const Color.fromARGB(255, 23, 118, 243)),
            if (!_showContent) _buildNameAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAnimation() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 23, 118, 243),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME ROW
            Row(
              mainAxisSize: MainAxisSize.min,
              children: name.split('').asMap().entries.map((entry) {
                final index = entry.key;
                final letter = entry.value;

                return AnimatedBuilder(
                  animation: _letterAnimations[index],
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _letterAnimations[index].value * 100,
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: _getResponsiveSize(context, 120, 80, 60),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                          shadows: const [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                            Shadow(
                              color: Color.fromARGB(80, 0, 0, 0),
                              blurRadius: 40,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            

            // LOADER (choose one option below)
            if (_nameAnimationComplete && _showLoader)
              // 👉 Option A (default): Pill button with spinner + subtle pulse
              _TimedProgressBar(duration: const Duration(seconds: 5)),


            // To try other options, comment the line above and uncomment one of these:
            // _DotsLoader(),
            // _TimedProgressBar(duration: const Duration(seconds: 5)),
          ],
        ),
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double desktop, double tablet, double phone) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return desktop;
    if (width > 600) return tablet;
    return phone;
  }
}

//
// ===== Loader Options =====
//

// Option A: Pill loading “button” with spinner + pulse
class _PillLoadingButton extends StatefulWidget {
  final String text;
  const _PillLoadingButton({required this.text});

  @override
  State<_PillLoadingButton> createState() => _PillLoadingButtonState();
}

class _PillLoadingButtonState extends State<_PillLoadingButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.035).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Option B: Three bouncing dots
class _DotsLoader extends StatefulWidget {
  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(period: const Duration(milliseconds: 900), reverse: true, min: 0.4),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const dotSize = 10.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controllers[i],
              curve: Curves.easeInOut,
            ),
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Option C: Timed progress bar filling over [duration]
class _TimedProgressBar extends StatefulWidget {
  final Duration duration;
  const _TimedProgressBar({required this.duration});

  @override
  State<_TimedProgressBar> createState() => _TimedProgressBarState();
}

class _TimedProgressBarState extends State<_TimedProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: widget.duration)..forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const barHeight = 6.0;
    return Container(
      width: 240,
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(barHeight),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _ac,
          builder: (_, __) {
            return Container(
              width: 240 * _ac.value,
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(barHeight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

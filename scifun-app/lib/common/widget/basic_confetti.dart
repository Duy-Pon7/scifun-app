import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

const Duration kSuccessConfettiDuration = Duration(milliseconds: 1600);
const Duration kSuccessConfettiCleanupDelay = Duration(milliseconds: 400);
final int kSuccessConfettiTotalDurationMs =
    kSuccessConfettiDuration.inMilliseconds +
        kSuccessConfettiCleanupDelay.inMilliseconds;

const double _kSuccessEmissionFrequency = 0.025;
const int _kSuccessParticlesPerBlast = 10;
const double _kSuccessMaxBlastForce = 16;
const double _kSuccessMinBlastForce = 8;
const double _kSuccessGravity = 0.1;

const List<Color> _kSuccessConfettiColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.pink,
  Colors.orange,
  Colors.purple,
];

/// Success Confetti Widget
/// Displays confetti animation from both sides of the screen
class SuccessConfetti extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SuccessConfetti({
    super.key,
    required this.child,
    this.duration = kSuccessConfettiDuration,
  });

  @override
  State<SuccessConfetti> createState() => _SuccessConfettiState();

  /// Launch confetti overlay
  static void launch(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) =>
          SuccessConfettiOverlay(onComplete: () => overlayEntry.remove()),
    );

    overlay.insert(overlayEntry);
  }
}

class _SuccessConfettiState extends State<SuccessConfetti> {
  late ConfettiController _controllerLeft;
  late ConfettiController _controllerRight;

  @override
  void initState() {
    super.initState();
    _controllerLeft = ConfettiController(duration: widget.duration);
    _controllerRight = ConfettiController(duration: widget.duration);
  }

  @override
  void dispose() {
    _controllerLeft.dispose();
    _controllerRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Left side confetti
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _controllerLeft,
            blastDirection: 0, // Right direction
            emissionFrequency: _kSuccessEmissionFrequency,
            numberOfParticles: _kSuccessParticlesPerBlast,
            maxBlastForce: _kSuccessMaxBlastForce,
            minBlastForce: _kSuccessMinBlastForce,
            gravity: _kSuccessGravity,
            shouldLoop: false,
            colors: _kSuccessConfettiColors,
          ),
        ),
        // Right side confetti
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _controllerRight,
            blastDirection: pi, // Left direction
            emissionFrequency: _kSuccessEmissionFrequency,
            numberOfParticles: _kSuccessParticlesPerBlast,
            maxBlastForce: _kSuccessMaxBlastForce,
            minBlastForce: _kSuccessMinBlastForce,
            gravity: _kSuccessGravity,
            shouldLoop: false,
            colors: _kSuccessConfettiColors,
          ),
        ),
      ],
    );
  }

  void play() {
    _controllerLeft.play();
    _controllerRight.play();
  }

  void stop() {
    _controllerLeft.stop();
    _controllerRight.stop();
  }
}

/// Success Confetti Overlay
/// Creates a temporary overlay with confetti animation
class SuccessConfettiOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const SuccessConfettiOverlay({super.key, required this.onComplete});

  @override
  State<SuccessConfettiOverlay> createState() => _SuccessConfettiOverlayState();
}

class _SuccessConfettiOverlayState extends State<SuccessConfettiOverlay> {
  late ConfettiController _controllerLeft;
  late ConfettiController _controllerRight;

  @override
  void initState() {
    super.initState();
    _controllerLeft = ConfettiController(duration: kSuccessConfettiDuration);
    _controllerRight = ConfettiController(duration: kSuccessConfettiDuration);

    // Start confetti
    _controllerLeft.play();
    _controllerRight.play();

    // Auto remove after duration
    Future.delayed(Duration(milliseconds: kSuccessConfettiTotalDurationMs), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controllerLeft.dispose();
    _controllerRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left side confetti
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _controllerLeft,
            blastDirection: 0, // Right direction
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: _kSuccessEmissionFrequency,
            numberOfParticles: _kSuccessParticlesPerBlast,
            maxBlastForce: _kSuccessMaxBlastForce,
            minBlastForce: _kSuccessMinBlastForce,
            gravity: _kSuccessGravity,
            shouldLoop: false,
            colors: _kSuccessConfettiColors,
          ),
        ),
        // Right side confetti
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _controllerRight,
            blastDirection: pi, // Left direction
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: _kSuccessEmissionFrequency,
            numberOfParticles: _kSuccessParticlesPerBlast,
            maxBlastForce: _kSuccessMaxBlastForce,
            minBlastForce: _kSuccessMinBlastForce,
            gravity: _kSuccessGravity,
            shouldLoop: false,
            colors: _kSuccessConfettiColors,
          ),
        ),
      ],
    );
  }
}

/// Simple function to launch success confetti
void launchSuccessConfetti(BuildContext context) {
  SuccessConfetti.launch(context);
}

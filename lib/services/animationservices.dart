import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationService {
  Future<void> playAnimation(
    BuildContext context,
    String url, {
    VoidCallback? onComplete,
    Duration? duration,
  }) async {
    try {
      // Show the animation in full-screen overlay
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FullScreenAnimation(
              url: url,
              onComplete: onComplete,
              duration: duration ?? const Duration(seconds: 3),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load animation: ${e.toString()}')),
      );
    }
  }
}

class FullScreenAnimation extends StatefulWidget {
  final String url;
  final VoidCallback? onComplete;
  final Duration duration;

  const FullScreenAnimation({
    Key? key,
    required this.url,
    this.onComplete,
    required this.duration,
  }) : super(key: key);

  @override
  State<FullScreenAnimation> createState() => _FullScreenAnimationState();
}

class _FullScreenAnimationState extends State<FullScreenAnimation> {
  late Duration _animationDuration;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    // Hide status bar for full immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _animationDuration = widget.duration;

    // Auto-close after the API specified duration
    Future.delayed(_animationDuration, () {
      if (mounted) {
        _closeAnimation();
      }
    });
  }

  void _closeAnimation() {
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    Navigator.of(context).pop();

    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closeAnimation();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _closeAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                // Full screen API animation/image
                Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      widget.url,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Failed to load animation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Close button (optional - can be removed if not needed)
                Positioned(
                  top: 60,
                  right: 20,
                  child: GestureDetector(
                    onTap: _closeAnimation,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Ensure status bar is restored
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }
}

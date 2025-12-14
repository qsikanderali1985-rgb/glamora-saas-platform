import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Modern animated icon wrapper for all app icons
/// Adds sophisticated hover, tap, and idle animations
class AnimatedIconWrapper extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  final bool enablePulse;
  final bool enableGlow;
  final bool enableRotation;
  final Gradient? gradient;

  const AnimatedIconWrapper({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.onTap,
    this.enablePulse = false,
    this.enableGlow = true,
    this.enableRotation = false,
    this.gradient,
  });

  @override
  State<AnimatedIconWrapper> createState() => _AnimatedIconWrapperState();
}

class _AnimatedIconWrapperState extends State<AnimatedIconWrapper>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late AnimationController _tapController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _tapAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Pulse animation (idle)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (widget.enableGlow) {
      _glowController.repeat(reverse: true);
    }
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    if (widget.enableRotation) {
      _rotateController.repeat();
    }
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Tap animation
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap != null ? _handleTap : null,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseController,
            _glowController,
            _rotateController,
            _tapController,
          ]),
          builder: (context, child) {
            Widget iconWidget = Icon(
              widget.icon,
              size: widget.size,
              color: widget.color ?? Colors.white,
            );

            if (widget.gradient != null) {
              iconWidget = ShaderMask(
                shaderCallback: (bounds) => widget.gradient!.createShader(bounds),
                child: iconWidget,
              );
            }

            if (widget.enableRotation) {
              iconWidget = Transform.rotate(
                angle: _rotateAnimation.value,
                child: iconWidget,
              );
            }

            double scale = _tapAnimation.value;
            if (widget.enablePulse) {
              scale *= _scaleAnimation.value;
            }
            if (_isHovered) {
              scale *= 1.15;
            }

            iconWidget = Transform.scale(
              scale: scale,
              child: iconWidget,
            );

            if (widget.enableGlow) {
              iconWidget = Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (widget.color ?? Colors.white).withValues(
                        alpha: _glowAnimation.value * (_isHovered ? 0.6 : 0.3),
                      ),
                      blurRadius: widget.size * 0.8 * (_isHovered ? 1.5 : 1.0),
                      spreadRadius: widget.size * 0.15,
                    ),
                  ],
                ),
                child: iconWidget,
              );
            }

            return iconWidget;
          },
        ),
      ),
    );
  }
}

/// Gradient icon button with advanced animations
class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final List<Color> gradientColors;
  final bool enableAnimations;

  const GradientIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
    this.gradientColors = const [Color(0xFFF8D7C4), Color(0xFFA855F7)],
    this.enableAnimations = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedIconWrapper(
      icon: icon,
      size: size,
      onTap: onTap,
      enableGlow: enableAnimations,
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

/// Floating action button with advanced animations
class AnimatedFloatingButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final List<Color> gradientColors;

  const AnimatedFloatingButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 60,
    this.gradientColors = const [
      Color(0xFFF8D7C4),
      Color(0xFFEC4899),
      Color(0xFFA855F7),
    ],
  });

  @override
  State<AnimatedFloatingButton> createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.gradientColors[1].withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: widget.gradientColors[0].withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(widget.size / 2),
                child: Center(
                  child: Transform.rotate(
                    angle: _rotateAnimation.value * 0.1, // Subtle rotation
                    child: Icon(
                      widget.icon,
                      size: widget.size * 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

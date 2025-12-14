import 'package:flutter/material.dart';

/// Glamora Advanced Logo Widget
/// Premium beauty & wellness brand identity with sophisticated design
class GlamoraLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool animate;

  const GlamoraLogo({
    super.key,
    this.size = 60,
    this.showText = true,
    this.primaryColor,
    this.secondaryColor,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final color1 = primaryColor ?? const Color(0xFFF8D7C4);
    final color2 = secondaryColor ?? const Color(0xFFA855F7);
    final color3 = const Color(0xFFEC4899); // Pink accent
    final color4 = const Color(0xFFFFD700); // Gold accent

    Widget logoIcon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color3, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color2.withValues(alpha: 0.4),
            blurRadius: size * 0.3,
            spreadRadius: size * 0.05,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main beauty symbol - Lipstick in center
          Positioned(
            top: size * 0.25,
            child: Icon(
              Icons.brush,
              size: size * 0.35,
              color: Colors.white,
            ),
          ),
          // Scissors symbol - hair cutting
          Positioned(
            bottom: size * 0.25,
            left: size * 0.2,
            child: Icon(
              Icons.content_cut,
              size: size * 0.25,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          // Star/sparkle for glamour
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Icon(
              Icons.auto_awesome,
              size: size * 0.2,
              color: color4,
            ),
          ),
          // Face/beauty icon
          Positioned(
            bottom: size * 0.25,
            right: size * 0.2,
            child: Icon(
              Icons.face,
              size: size * 0.25,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );

    if (animate) {
      logoIcon = _AnimatedLogoIcon(child: logoIcon);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoIcon,
        if (showText) ...[
          SizedBox(width: size * 0.25),
          // Advanced Logo Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [color1, color3, color2, color4],
                  stops: const [0.0, 0.33, 0.66, 1.0],
                ).createShader(bounds),
                child: Text(
                  'GLAMORA',
                  style: TextStyle(
                    fontSize: size * 0.65,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color1.withValues(alpha: 0.25),
                      color2.withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'BEAUTY & WELLNESS',
                  style: TextStyle(
                    fontSize: size * 0.18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Icon-only version for smaller spaces
class GlamoraIcon extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? secondaryColor;

  const GlamoraIcon({
    super.key,
    this.size = 40,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlamoraLogo(
      size: size,
      showText: false,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }
}

/// Animated logo icon wrapper
class _AnimatedLogoIcon extends StatefulWidget {
  final Widget child;

  const _AnimatedLogoIcon({required this.child});

  @override
  State<_AnimatedLogoIcon> createState() => _AnimatedLogoIconState();
}

class _AnimatedLogoIconState extends State<_AnimatedLogoIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
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
          child: widget.child,
        );
      },
    );
  }
}

/// Animated Logo with shimmer effect
class AnimatedGlamoraLogo extends StatefulWidget {
  final double size;
  final bool showText;

  const AnimatedGlamoraLogo({
    super.key,
    this.size = 60,
    this.showText = true,
  });

  @override
  State<AnimatedGlamoraLogo> createState() => _AnimatedGlamoraLogoState();
}

class _AnimatedGlamoraLogoState extends State<AnimatedGlamoraLogo>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _shimmerController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFF5F0),
                  Color(0xFFFFFFFF),
                ],
                stops: [
                  (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                  _shimmerAnimation.value.clamp(0.0, 1.0),
                  (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                ],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: GlamoraLogo(
              size: widget.size,
              showText: widget.showText,
              animate: true,
            ),
          ),
        );
      },
    );
  }
}

/// Minimal logo for app bar
class GlamoraAppBarLogo extends StatelessWidget {
  const GlamoraAppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlamoraLogo(
      size: 32,
      showText: false,
    );
  }
}

/// Full logo for splash screen
class GlamoraSplashLogo extends StatelessWidget {
  const GlamoraSplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedGlamoraLogo(
      size: 120,
      showText: true,
    );
  }
}

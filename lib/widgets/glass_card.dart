import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? glowShadow;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 16.0,
    this.padding,
    this.glowShadow,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? colorScheme.outline.withOpacity(0.3),
          width: borderWidth,
        ),
        boxShadow: glowShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class NeonGlassCard extends StatefulWidget {
  final Widget child;
  final Color neonColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const NeonGlassCard({
    super.key,
    required this.child,
    required this.neonColor,
    this.borderRadius = 20.0,
    this.padding,
    this.onTap,
  });

  @override
  State<NeonGlassCard> createState() => _NeonGlassCardState();
}

class _NeonGlassCardState extends State<NeonGlassCard> with SingleTickerProviderStateMixin {
  bool _isInteracting = false;
  late AnimationController _shinyController;

  @override
  void initState() {
    super.initState();
    _shinyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _shinyController.dispose();
    super.dispose();
  }

  void _triggerShiny() {
    if (!_shinyController.isAnimating) {
      _shinyController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isInteracting = true);
        _triggerShiny();
      },
      onExit: (_) => setState(() => _isInteracting = false),
      child: GestureDetector(
        onTap: () {
          _triggerShiny();
          widget.onTap?.call();
        },
        onTapDown: (_) => setState(() => _isInteracting = true),
        onTapUp: (_) => setState(() => _isInteracting = false),
        onTapCancel: () => setState(() => _isInteracting = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _isInteracting ? 1.02 : 1.0,
          curve: Curves.easeOutCubic,
          child: RepaintBoundary(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: _isInteracting
                          ? widget.neonColor.withOpacity(0.8)
                          : widget.neonColor.withOpacity(isDark ? 0.3 : 0.5),
                      width: 1.0,
                    ),
                    boxShadow: _isInteracting
                        ? [
                            BoxShadow(
                              color: widget.neonColor.withOpacity(0.4),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: widget.neonColor.withOpacity(0.15),
                              blurRadius: 56,
                              spreadRadius: 0,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: widget.child,
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: AnimatedBuilder(
                        animation: _shinyController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ShinyPainter(
                              progress: _shinyController.value,
                              color: widget.neonColor,
                            ),
                          );
                        },
                      ),
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
}

class ShinyPainter extends CustomPainter {
  final double progress;
  final Color color;

  ShinyPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;

    // Calculate position for the sweep
    // We want the sweep to move from -width to +width*2
    double xPos = (progress * size.width * 3) - size.width;
    
    final sweepPaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1.0, -1.0),
        end: const Alignment(1.0, 1.0),
        colors: [
          Colors.transparent,
          color.withOpacity(0.0),
          color.withOpacity(0.6),
          color.withOpacity(0.0),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(xPos, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sweepPaint);
  }

  @override
  bool shouldRepaint(ShinyPainter oldDelegate) => oldDelegate.progress != progress;
}

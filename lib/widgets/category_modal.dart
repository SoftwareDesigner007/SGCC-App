import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import '../models/category_model.dart';

void showCategoryModal(BuildContext context, CategoryModel category) {
  // Capture the MainShellState from the CALLER's context BEFORE opening the sheet.
  // The bottom sheet overlay has its own widget tree, so findAncestorStateOfType
  // won't work from inside the modal.
  final shellState = context.findAncestorStateOfType<MainShellState>();

  showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CategoryModal(category: category),
  ).then((shouldNavigate) {
    // This runs AFTER the bottom sheet is fully closed
    if (shouldNavigate == true) {
      shellState?.setIndex(1);
    }
  });
}

class CategoryModal extends StatefulWidget {
  final CategoryModel category;

  const CategoryModal({
    super.key,
    required this.category,
  });

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal>
    with TickerProviderStateMixin {
  bool _isSparkleActive = false;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  void _handleViewAllCourses() {
    setState(() => _isSparkleActive = true);
    _sparkleController.forward(from: 0.0);

    // Wait for the sparkle animation to play, then close the sheet
    // and return `true` to tell the caller to navigate to courses.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      Navigator.pop(context, true); // Return true = navigate to courses
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = widget.category;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, ctrl) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                  color: category.accentColor.withOpacity(0.4), width: 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: category.accentColor.withOpacity(0.12),
                blurRadius: 40,
              ),
            ],
          ),
          child: ListView(
            controller: ctrl,
            padding: const EdgeInsets.all(24),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Icon + close
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: category.accentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: category.accentColor.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Icon(category.iconData,
                        color: category.accentColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      category.title,
                      style: GoogleFonts.sora(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? category.accentColor
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: Icon(Icons.close,
                        color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Definition
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: category.accentColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: category.accentColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  category.definition,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.65,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Example
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category.example,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? category.accentColor.withOpacity(0.9)
                        : colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
              Divider(color: colorScheme.outline.withOpacity(0.4)),
              const SizedBox(height: 8),
              Text(
                'COURSES WE OFFER',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              ...category.courses.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: category.accentColor, size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          c,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // CTA Button with sparkle animation
              _buildSparkleButton(category, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSparkleButton(
      CategoryModel category, ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          // The button
          GestureDetector(
            onTap: _isSparkleActive ? null : _handleViewAllCourses,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: category.accentColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: category.accentColor.withOpacity(
                        _isSparkleActive ? 0.6 : 0.35),
                    blurRadius: _isSparkleActive ? 30 : 20,
                    spreadRadius: _isSparkleActive ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VIEW ALL COURSES',
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isSparkleActive ? 0.5 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
          // Sparkle/shimmer overlay
          if (_isSparkleActive)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                )
                    .animate(controller: _sparkleController)
                    .shimmer(
                      duration: 600.ms,
                      color: Colors.white.withOpacity(0.5),
                      angle: 45 * pi / 180,
                    )
                    .then()
                    .fadeOut(duration: 200.ms),
              ),
            ),
          // Sparkle particles
          if (_isSparkleActive)
            Positioned.fill(
              child: IgnorePointer(
                child: _SparkleParticles(
                  color: Colors.white,
                  controller: _sparkleController,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter that renders sparkle/glitter particles
class _SparkleParticles extends StatelessWidget {
  final Color color;
  final AnimationController controller;

  const _SparkleParticles({
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _SparklePainter(
            color: color,
            progress: controller.value,
          ),
        );
      },
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;
  final double progress;
  final Random _random = Random(42); // Fixed seed for consistent sparkle positions

  _SparklePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()..color = color;
    const sparkleCount = 20;

    for (int i = 0; i < sparkleCount; i++) {
      final baseX = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;

      // Each sparkle has its own timing offset
      final delay = _random.nextDouble() * 0.4;
      final localProgress = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);

      if (localProgress <= 0) continue;

      // Sparkle bursts outward and fades
      final scale = sin(localProgress * pi);
      final sparkleSize = (2 + _random.nextDouble() * 3) * scale;

      // Move outward from center
      final dx = (baseX - size.width / 2) * 0.3 * localProgress;
      final dy = (baseY - size.height / 2) * 0.5 * localProgress;

      final x = baseX + dx;
      final y = baseY + dy - (20 * localProgress); // Float upward

      final opacity = (1.0 - localProgress) * 0.9;
      paint.color = color.withOpacity(opacity);

      // Draw a 4-pointed star shape
      _drawStar(canvas, Offset(x, y), sparkleSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    if (size < 0.5) return;

    // Horizontal line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size * 2, height: size * 0.4),
        Radius.circular(size * 0.2),
      ),
      paint,
    );
    // Vertical line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size * 0.4, height: size * 2),
        Radius.circular(size * 0.2),
      ),
      paint,
    );
    // Bright center dot
    final dotPaint = Paint()..color = paint.color.withOpacity(1.0);
    canvas.drawCircle(center, size * 0.3, dotPaint);
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

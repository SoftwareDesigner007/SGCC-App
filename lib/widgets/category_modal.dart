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
      if (shellState != null) {
        shellState.setIndex(1);
      } else {
        // Fallback: If for some reason shellState is null, we can try to push the home route with index 1
        // though setIndex is preferred.
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false, arguments: 1);
      }
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // The button using Material and InkWell for guaranteed hits
            Material(
              color: category.accentColor,
              child: InkWell(
                onTap: _isSparkleActive ? null : _handleViewAllCourses,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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

    const sparkleCount = 25; // Increased count
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < sparkleCount; i++) {
      // Use index for varied positions
      final seed = 42 + i;
      final random = Random(seed);
      
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Each sparkle has its own timing offset
      final delay = random.nextDouble() * 0.3;
      final localProgress = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);

      if (localProgress <= 0) continue;

      // Color variation between white and gold
      final isGold = random.nextBool();
      final sparkleColor = isGold 
          ? const Color(0xFFFFD700) // Gold
          : Colors.white;

      // Sparkle bursts outward and fades
      final scale = sin(localProgress * pi);
      final sparkleSize = (3 + random.nextDouble() * 4) * scale; // Slightly larger

      // Move outward from center for a "burst" effect
      final dirX = (baseX - center.dx) / size.width;
      final dirY = (baseY - center.dy) / size.height;
      
      final dx = dirX * size.width * 0.4 * localProgress;
      final dy = dirY * size.height * 0.6 * localProgress;

      final x = baseX + dx;
      final y = baseY + dy - (30 * localProgress); // Float upward more

      final paint = Paint()
        ..color = sparkleColor.withOpacity((1.0 - localProgress) * 0.9);

      // Draw a more complex star shape
      _drawSparkleStar(canvas, Offset(x, y), sparkleSize, paint);
    }
  }

  void _drawSparkleStar(Canvas canvas, Offset center, double size, Paint paint) {
    if (size < 0.5) return;

    // Main cross
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size * 2.5, height: size * 0.3),
        Radius.circular(size * 0.1),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size * 0.3, height: size * 2.5),
        Radius.circular(size * 0.1),
      ),
      paint,
    );

    // Diagonal small cross for extra sparkle
    final diagonalPaint = Paint()..color = paint.color.withOpacity(paint.color.opacity * 0.7);
    final diagSize = size * 1.2;
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(pi / 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: diagSize, height: diagSize * 0.2),
        Radius.circular(diagSize * 0.1),
      ),
      diagonalPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: diagSize * 0.2, height: diagSize),
        Radius.circular(diagSize * 0.1),
      ),
      diagonalPaint,
    );
    canvas.restore();

    // Bright center dot
    final dotPaint = Paint()..color = Colors.white.withOpacity(paint.color.opacity);
    canvas.drawCircle(center, size * 0.4, dotPaint);
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

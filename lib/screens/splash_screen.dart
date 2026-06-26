import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final List<String> _quotes = [
    "Study hard, but study smart. Your future is created by what you do today.",
    "Success is the sum of small efforts, repeated day in and day out.",
    "The expert in anything was once a beginner. Keep learning.",
    "Don't just study to pass. Study to learn, understand, and grow.",
    "Smart work is the key to unlocking your true potential.",
    "Work hard in silence, let your success be your noise.",
    "Education is the most powerful weapon which you can use to change the world.",
    "Push yourself, because no one else is going to do it for you.",
  ];
  late String _randomQuote;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _randomQuote = _quotes[Random().nextInt(_quotes.length)];
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressController.forward().then((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      });
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A1320),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Properly visible edge-to-edge curved square logo (NO FADE IN, so it perfectly matches the native splash)
            Center(
              child: Image.asset(
                'assets/images/Logo.webp',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
                cacheWidth: 320,
              ),
            ),
            const SizedBox(height: 40),
            // Motivational Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _randomQuote,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms),
            ),
            const Spacer(),
            // Loading Sign with Percentage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final progress = _progressController.value;
                  final percentage = (progress * 100).toInt();
                  return Column(
                    children: [
                      Text(
                        '$percentage%',
                        style: GoogleFonts.sora(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: constraints.maxWidth * progress,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.secondary,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.secondary.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Optimizing Experience...',
                        style: GoogleFonts.sora(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white60,
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(begin: 0.5, end: 1.0, duration: 1.seconds),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

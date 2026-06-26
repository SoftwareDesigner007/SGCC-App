import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import '../models/category_model.dart';
import '../models/course_model.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/enquiry_modal.dart';
import '../widgets/category_modal.dart';
import '../widgets/custom_filter_chip.dart';
import '../widgets/custom_section_header.dart';
import '../widgets/typewriter_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _sparkleCtrl;
  final FlutterTts flutterTts = FlutterTts();

  // Campus image carousel
  Timer? _campusAutoSlideTimer;
  int _campusCurrentPage = 0;
  final List<String> _campusImages = const [
    'assets/images/Campus 1.webp',
    'assets/images/Campus 2.webp',
    'assets/images/Campus 3.webp',
    'assets/images/Campus 4.webp',
    'assets/images/Image 2.webp',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _sparkleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _startCampusAutoSlide();
  }

  void _startCampusAutoSlide() {
    _campusAutoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        _campusCurrentPage = (_campusCurrentPage + 1) % _campusImages.length;
      });
    });
  }

  Future<void> _playWelcomeMessage() async {
    _sparkleCtrl.forward(from: 0.0);
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak("Welcome to Shree Ganesh Computer Classes");
  }

  @override
  void dispose() {
    _campusAutoSlideTimer?.cancel();
    _pulseCtrl.dispose();
    _sparkleCtrl.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        cacheExtent: 1000, // Optimize scrolling
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildHero())),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildAffiliationsStrip())),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildCampusPreview())),
          SliverToBoxAdapter(child: _buildWhySGCC()),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildMSCITSpotlight())),
          SliverToBoxAdapter(child: _buildFeaturedCourses()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildStudyMaterialCTA())),
          SliverToBoxAdapter(child: RepaintBoundary(child: _buildGaneshGitaShloka())),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: colorScheme.surface.withOpacity(0.95),
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      title: RepaintBoundary(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {}, // Add your logic or just trigger the animation
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/Logo.webp',
                    fit: BoxFit.contain,
                    cacheWidth: 88,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SGCC',
                      style: GoogleFonts.sora(
                          fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5,
                          shadows: [
                            Shadow(color: colorScheme.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 2))
                          ],
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [colorScheme.tertiary, colorScheme.primary, colorScheme.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(const Rect.fromLTWH(0, 0, 100, 26)))),
                  const SizedBox(height: 2),
                  Text('Shree Ganesh Computer Classes',
                      style: GoogleFonts.inter(
                          fontSize: 10.5, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withOpacity(0.85), letterSpacing: 0.2),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                final current = SGCCApp.themeNotifier.value;
                if (current == ThemeMode.dark) {
                  SGCCApp.themeNotifier.value = ThemeMode.light;
                } else {
                  SGCCApp.themeNotifier.value = ThemeMode.dark;
                }
              },
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () => showEnquiryModal(context),
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('Enquire',
                  style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: colorScheme.primary.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildHero() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [colorScheme.primary.withOpacity(0.08), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Admissions badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colorScheme.secondary.withOpacity(0.4)),
                          color: colorScheme.secondary.withOpacity(0.05),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.secondary.withOpacity(0.5 + _pulseCtrl.value * 0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('ADMISSIONS OPEN 2026–2027',
                                style: GoogleFonts.inter(
                                    fontSize: 10, fontWeight: FontWeight.w700,
                                    color: colorScheme.secondary, letterSpacing: 1.5)),
                          ],
                        ),
                      ).animate().shimmer(duration: 6.seconds, color: colorScheme.secondary.withOpacity(0.15)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: colorScheme.secondary.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: -2,
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/Logo.webp',
                        fit: BoxFit.contain,
                        cacheWidth: 180,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _playWelcomeMessage,
                            splashColor: Colors.white.withOpacity(0.5),
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0), curve: Curves.elasticOut)
              .animate(controller: _sparkleCtrl, autoPlay: false)
                .shimmer(duration: 1200.ms, color: Colors.white, size: 3)
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 400.ms, curve: Curves.easeOut)
                .then()
                .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 400.ms, curve: Curves.easeIn),
            ],
          ),
          const SizedBox(height: 20),
          // Sacred Text
          Text(
            'ॐ श्री गणेशाय नमः',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colorScheme.tertiary,
              shadows: [
                Shadow(
                  color: colorScheme.tertiary.withOpacity(0.4),
                  blurRadius: 10,
                )
              ],
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 8),
          // Headline
          RichText(
            text: TextSpan(
              style: GoogleFonts.sora(fontSize: 36, fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface, height: 1.1, letterSpacing: -1),
              children: [
                const TextSpan(text: 'Ignite '),
                TextSpan(text: 'Skills.\n',
                    style: TextStyle(color: colorScheme.primary,
                        shadows: [Shadow(color: colorScheme.primary.withOpacity(0.6), blurRadius: 20)])),
                const TextSpan(text: 'Shape '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: TypewriterText(
                    texts: const ['Futures.', 'Careers.', 'Life Goals.', 'Dreams.'],
                    style: GoogleFonts.sora(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.secondary,
                      height: 1.1,
                      letterSpacing: -1,
                      shadows: [Shadow(color: colorScheme.secondary.withOpacity(0.6), blurRadius: 20)],
                    ),
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0)
            .shimmer(delay: 1.seconds, duration: 3.seconds, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "Master the digital frontier with Mumbai's premier tech education hub. From foundational computing to advanced software engineering, we build the architects of tomorrow.",
            style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant, height: 1.7),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  label: 'Explore Courses',
                  onPressed: () {
                    context.findAncestorStateOfType<MainShellState>()?.setIndex(1);
                  },
                  icon: Icons.arrow_forward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeonButton(
                  label: 'Enquire Now',
                  onPressed: () => showEnquiryModal(context),
                  color: colorScheme.secondary,
                  textColor: colorScheme.onSecondary,
                  outlined: true,
                ),
              ),
            ],
          ).animate(delay: 400.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          // New Hero Section Brochure Button
          SizedBox(
            width: double.infinity,
            child: NeonButton(
              label: 'View Course Brochure',
              icon: Icons.picture_as_pdf_outlined,
              color: colorScheme.secondary,
              textColor: colorScheme.onSecondary,
              onPressed: () async {
                final uri = Uri.parse('https://drive.google.com/drive/folders/1UQjW5FW8uj85rVUgkxJgPqDcSqlJaKid?usp=sharing');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ).animate(delay: 500.ms).fadeIn(duration: 600.ms),
          ),
          const SizedBox(height: 32),
          // Stats
          const Row(
            children: [
              _StatItem(value: '25+', label: 'Years of\nExcellence'),
              _StatDivider(),
              _StatItem(value: '15k+', label: 'Certified\nAlumni'),
              _StatDivider(),
              _StatItem(value: '50+', label: 'Expert\nFaculty'),
            ],
          ).animate(delay: 600.ms).fadeIn(duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildAffiliationsStrip() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkSurfaceContainer 
            : AppColors.lightSurfaceContainer,
        border: Border.symmetric(
          horizontal: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          Text('OFFICIAL AFFILIATIONS', 
              style: GoogleFonts.inter(
                fontSize: 10, 
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurfaceVariant.withOpacity(0.6), 
                letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _affiliation('assets/images/mkcl-logo.webp', 'Authorized', colorScheme.primary),
              const SizedBox(width: 32),
              _affiliation('assets/images/ycmou-logo.webp', 'Study Center', colorScheme.secondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _affiliation(String assetPath, String label, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
            Text(assetPath.contains('mkcl') ? 'MKCL' : 'YCMOU', 
                style: GoogleFonts.sora(
                  fontSize: 14, 
                  fontWeight: FontWeight.w800, 
                  color: colorScheme.onSurface)),
          ],
        ),
      ],
    );
  }

  void _goToCampusPage(int index) {
    setState(() {
      _campusCurrentPage = index % _campusImages.length;
    });
    _campusAutoSlideTimer?.cancel();
    _startCampusAutoSlide();
  }

  Widget _buildCampusPreview() {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Column(
        children: [
          // Shimmer border wrapper
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(isDark ? 0.25 : 0.12),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: colorScheme.secondary.withOpacity(isDark ? 0.15 : 0.08),
                  blurRadius: 40,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          colorScheme.primary.withOpacity(0.6),
                          colorScheme.secondary.withOpacity(0.3),
                          colorScheme.primary.withOpacity(0.1),
                          colorScheme.secondary.withOpacity(0.6),
                        ]
                      : [
                          colorScheme.primary.withOpacity(0.4),
                          colorScheme.outline.withOpacity(0.3),
                          colorScheme.primary.withOpacity(0.1),
                          colorScheme.secondary.withOpacity(0.4),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image with AnimatedSwitcher
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 900),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.03, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          _campusImages[_campusCurrentPage],
                          key: ValueKey<int>(_campusCurrentPage),
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          cacheWidth: 1200,
                          gaplessPlayback: true,
                        ),
                      ),
                      // Left arrow
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _goToCampusPage(
                              (_campusCurrentPage - 1 + _campusImages.length) % _campusImages.length,
                            ),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.black.withOpacity(0.55)
                                    : Colors.white.withOpacity(0.8),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.black.withOpacity(0.08),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Right arrow
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _goToCampusPage(_campusCurrentPage + 1),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.black.withOpacity(0.55)
                                    : Colors.white.withOpacity(0.8),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.black.withOpacity(0.08),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Image counter badge
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDark
                                ? Colors.black.withOpacity(0.6)
                                : Colors.white.withOpacity(0.85),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.06),
                            ),
                          ),
                          child: Text(
                            '${_campusCurrentPage + 1} / ${_campusImages.length}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              .animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_campusImages.length, (index) {
              final isActive = index == _campusCurrentPage;
              return GestureDetector(
                onTap: () => _goToCampusPage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isActive
                        ? colorScheme.primary
                        : (isDark
                            ? colorScheme.onSurfaceVariant.withOpacity(0.25)
                            : colorScheme.onSurfaceVariant.withOpacity(0.2)),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(isDark ? 0.5 : 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Shree Ganesh Computer Classes campus preview',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildWhySGCC() {
    final colorScheme = Theme.of(context).colorScheme;
    final cards = [
      {'icon': Icons.psychology_outlined, 'color': colorScheme.primary,
        'title': 'Expert Mentorship',
        'desc': 'Learn from industry veterans with 20+ years of hands-on experience in software development and IT training.'},
      {'icon': Icons.rocket_launch_outlined, 'color': colorScheme.secondary,
        'title': 'Modern Curriculum',
        'desc': 'Our syllabus is updated bi-annually to stay in sync with the rapidly evolving global technology landscape.'},
      {'icon': Icons.work_outline, 'color': colorScheme.tertiary,
        'title': 'Placement Ready',
        'desc': 'Dedicated mock interviews and soft-skills training modules to ensure you are ready for top MNC recruitment.'},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepaintBoundary(child: CustomSectionHeader(normal: 'Why SGCC', colored: 'Stands Out', color: colorScheme.primary)),
          const SizedBox(height: 20),
          ...cards.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: NeonGlassCard(
                neonColor: c['color'] as Color,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['title'] as String,
                              style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(c['desc'] as String,
                              style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: (i * 100).ms).slideX(begin: 0.1, end: 0),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMSCITSpotlight() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: NeonGlassCard(
        neonColor: colorScheme.secondary,
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
              ),
              child: Text('FLAGSHIP CERTIFICATION',
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700,
                      color: colorScheme.secondary, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 14),
            Text('MS-CIT\n',
                style: GoogleFonts.sora(fontSize: 30, fontWeight: FontWeight.w900, color: colorScheme.onSurface, height: 1)),
            Text('Mastery Program',
                style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.secondary)),
            const SizedBox(height: 12),
            Text("The gold standard for digital literacy in Maharashtra. We go beyond the basics — advanced Excel, Professional Presentations, and Internet Security.",
                style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.6)),
            const SizedBox(height: 16),
            ...[
              'Govt. Recognized Certification',
              'Hands-on Lab Training',
              'Updated 2026–2027 Courseware',
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colorScheme.secondary, size: 16),
                  const SizedBox(width: 10),
                  Text(item, style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurface)),
                ],
              ),
            )),
            const SizedBox(height: 20),
            NeonButton(
              label: 'Enroll Now',
              color: colorScheme.secondary,
              textColor: colorScheme.onSecondary,
              onPressed: () => showEnquiryModal(context, preselectedCourse: "MKCL'S MSCIT"),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://drive.google.com/file/d/1FlOFiXYJprJ0YXc0V4P2juN2meZB673a/view?usp=drive_link');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                label: Text('View Brochure', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.secondary,
                  side: BorderSide(color: colorScheme.secondary.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    final colorScheme = Theme.of(context).colorScheme;
    final featured = allCourses.where((c) =>
        c.id == 'web' || c.id == 'uiux' || c.id == 'tally').toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RepaintBoundary(child: CustomSectionHeader(normal: 'Elite', colored: 'Curriculums', color: colorScheme.primary)),
              TextButton(
                onPressed: () {
                  context.findAncestorStateOfType<MainShellState>()?.setIndex(1);
                },
                child: Row(children: [
                  Text('View All', style: GoogleFonts.sora(fontSize: 12, color: colorScheme.secondary, fontWeight: FontWeight.w700)),
                  Icon(Icons.arrow_forward, color: colorScheme.secondary, size: 16),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...featured.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NeonGlassCard(
                neonColor: c.accentColor,
                padding: const EdgeInsets.all(18),
                onTap: () => showEnquiryModal(context, preselectedCourse: c.name),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: c.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(c.icon, color: c.accentColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(c.description, style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(c.duration, style: GoogleFonts.inter(fontSize: 11, color: c.accentColor, fontWeight: FontWeight.w600)),
                        Icon(Icons.arrow_right_alt, color: colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: (i * 100).ms).slideX(begin: -0.1, end: 0),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        children: [
          RepaintBoundary(child: CustomSectionHeader(normal: 'Our Learning', colored: 'Categories', color: colorScheme.secondary)),
          const SizedBox(height: 6),
          Text('Tap any category to explore what we offer',
              style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 0.85,
            children: learningCategories.map((cat) => NeonGlassCard(
              neonColor: cat.accentColor,
              borderRadius: 22,
              padding: const EdgeInsets.all(20),
              onTap: () => showCategoryModal(context, cat),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58, height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cat.accentColor.withOpacity(0.15),
                    ),
                    child: Icon(cat.iconData, color: cat.accentColor, size: 30),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    cat.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: colorScheme.onSurface, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap to explore →',
                    style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyMaterialCTA() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: NeonGlassCard(
        neonColor: colorScheme.primary,
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Empowering Students Everywhere',
                style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('Access our exclusive repository of free study materials, coding cheat sheets, and MS-CIT practice modules.',
                style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.6),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            NeonButton(
              label: 'Access Resources',
              icon: Icons.download_outlined,
              onPressed: () {
                context.findAncestorStateOfType<MainShellState>()?.setIndex(4);
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaneshGitaShloka() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: NeonGlassCard(
        neonColor: colorScheme.tertiary,
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.tertiary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'गणेश गीता',
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                ),
                const SizedBox(width: 8),
                Icon(Icons.auto_awesome, color: colorScheme.tertiary, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'स्वस्वकर्मरताः सर्वे मय्यर्पितफलाः नराः।\nमत्प्रसादात्स्थिरं स्थानं यान्ति ते नात्र संशयः॥',
              style: GoogleFonts.sora(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.tertiary,
                height: 1.6,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.darkSurfaceContainer 
                    : AppColors.lightSurfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Svasva-karma-ratāḥ sarve mayyarpita-phalāḥ narāḥ ।\nMat-prasādāt sthiraṁ sthānaṁ yānti te nātra saṁśayaḥ ॥',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  Text(
                    'भगवान गणेश कहते हैं:\n"जो मनुष्य अपने-अपने कर्तव्य (धर्म) को निष्ठापूर्वक करते हैं और अपने कर्मों के फल मुझे समर्पित कर देते हैं, वे मेरी कृपा से परम और स्थिर पद को प्राप्त होते हैं। इसमें तनिक भी संदेह नहीं है।"',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(value, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: colorScheme.onSurfaceVariant, height: 1.4)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, 
      height: 40, 
      color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

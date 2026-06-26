import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../models/course_model.dart';
import '../widgets/course_card.dart';
import '../widgets/custom_filter_chip.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selected = 'All Programs';

  List<CourseModel> get _filtered => _selected == 'All Programs'
      ? allCourses
      : allCourses.where((c) => c.category == _selected).toList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: colorScheme.surface.withOpacity(0.95),
            elevation: 0,
            expandedHeight: 140,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: colorScheme.primary.withOpacity(0.2)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: RichText(
                text: TextSpan(
                  style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(text: 'FUTURE ', style: TextStyle(color: colorScheme.onSurface)),
                    TextSpan(text: 'SKILLS ',
                        style: TextStyle(color: colorScheme.primary,
                            shadows: [Shadow(color: colorScheme.primary.withOpacity(0.6), blurRadius: 16)])),
                    TextSpan(text: 'CATALOG', style: TextStyle(color: colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Unlock the next generation of technical expertise. Master the tools of tomorrow\'s digital economy.',
                      style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: courseCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = courseCategories[i];
                        final isSelected = cat == _selected;
                        return CustomFilterChip(
                          label: cat,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selected = cat),
                        ).animate().fadeIn(duration: 300.ms, delay: (i * 50).ms).slideX(begin: 0.1, end: 0);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: CourseCard(course: _filtered[i])
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (i * 50).ms)
                      .slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
                ),
                childCount: _filtered.length,
              ),
            ),
          ),
          // CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkSurfaceContainer 
                      : AppColors.lightSurfaceContainer),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.35)),
                ),
                child: Column(
                  children: [
                    Text("CAN'T FIND WHAT YOU'RE LOOKING FOR?",
                        style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text('Contact our career counselors for a personalized learning path tailored to your goals.',
                        style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.6),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Download Brochure',
                          style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


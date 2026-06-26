import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../models/resource_model.dart';
import '../widgets/custom_filter_chip.dart';

class StudyMaterialScreen extends StatefulWidget {
  const StudyMaterialScreen({super.key});

  @override
  State<StudyMaterialScreen> createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {
  String _selected = 'All Resources';

  List<ResourceModel> get _filtered => _selected == 'All Resources'
      ? studyResources
      : studyResources.where((r) => r.category == _selected).toList();

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
            expandedHeight: 110,
            bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: colorScheme.primary.withOpacity(0.2))),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: RichText(text: TextSpan(
                style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(text: 'Free ', style: TextStyle(color: colorScheme.onSurface)),
                  TextSpan(text: 'Study Materials',
                      style: TextStyle(color: colorScheme.secondary,
                          shadows: [Shadow(color: colorScheme.secondary.withOpacity(0.5), blurRadius: 12)])),
                ],
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text('Access our exclusive repository of free study materials, coding cheat sheets, and MS-CIT practice modules.',
                      style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.6)),
                ),
                const SizedBox(height: 16),
                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: resourceCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = resourceCategories[i];
                      final isSelected = cat == _selected;
                      return CustomFilterChip(
                        label: cat,
                        isSelected: isSelected,
                        activeColor: colorScheme.secondary,
                        onTap: () => setState(() => _selected = cat),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ResourceCard(resource: _filtered[i])
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (i * 50).ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                ),
                childCount: _filtered.length,
              ),
            ),
          ),
          // Bottom CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary.withOpacity(0.15), colorScheme.secondary.withOpacity(0.15)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                ),
                child: Column(children: [
                  Icon(Icons.cloud_download_outlined, color: colorScheme.primary, size: 40),
                  const SizedBox(height: 12),
                  Text('Want More Resources?',
                      style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  Text('Visit campus or contact us. Our faculty provides additional practice sets and notes.',
                      style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.6),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.parse('tel:+918898919457');
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                    child: Text('Contact Us', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceModel resource;
  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: resource.accentColor.withOpacity(0.25)),
      ),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: resource.accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(resource.icon, color: resource.accentColor, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(resource.title,
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            if (resource.isFree)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
                ),
                child: Text('FREE', style: GoogleFonts.inter(
                    fontSize: 9, fontWeight: FontWeight.w800, color: colorScheme.secondary, letterSpacing: 1)),
              ).animate().shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5)),
          ]),
          const SizedBox(height: 4),
          Text(resource.subtitle,
              style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.4),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: resource.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(resource.category,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: resource.accentColor)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                if (resource.downloadUrl == 'coming_soon') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Coming Soon', style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: colorScheme.onSurface, fontSize: 18)),
                          ),
                        ],
                      ),
                      content: Text('This resource will be available soon. Stay tuned!',
                          style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK', style: GoogleFonts.sora(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                
                if (resource.downloadUrl != null && resource.downloadUrl!.isNotEmpty) {
                  final uri = Uri.parse(resource.downloadUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the link.')),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No link available.')),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.download_outlined, color: colorScheme.primary, size: 14),
                  const SizedBox(width: 4),
                  Text('Access', style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.primary)),
                ]),
              ),
            ),
          ]),
        ])),
      ]),
    );
  }
}

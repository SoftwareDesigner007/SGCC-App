import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHero(context)),
          SliverToBoxAdapter(child: _buildCampusPreview(context)),
          SliverToBoxAdapter(child: _buildMissionVision(context)),
          SliverToBoxAdapter(child: _buildPhilosophy(context)),
          SliverToBoxAdapter(child: _buildAffiliations(context)),
          SliverToBoxAdapter(child: _buildTimeline(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Text('About SGCC', style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: colorScheme.primary.withOpacity(0.2))),
    );
  }

  Widget _buildHero(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('THE SGCC STORY',
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700,
                color: colorScheme.secondary, letterSpacing: 2.5)),
        const SizedBox(height: 12),
        RichText(text: TextSpan(
          style: GoogleFonts.sora(fontSize: 30, fontWeight: FontWeight.w800, color: colorScheme.onSurface, height: 1.15),
          children: [
            const TextSpan(text: 'Legacy of '),
            TextSpan(text: 'Digital Excellence',
                style: TextStyle(color: colorScheme.primary, fontStyle: FontStyle.italic,
                    shadows: [Shadow(color: colorScheme.primary.withOpacity(0.5), blurRadius: 20)])),
            const TextSpan(text: '\nIn Mumbai.'),
          ],
        )),
        const SizedBox(height: 14),
        Text('Born in the heart of Bandra East, Shree Ganesh Computer Classes (SGCC) has been the cornerstone of technical literacy for over two decades. We bridge the gap between traditional education and the futuristic demands of the digital economy.',
            style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant, height: 1.7)),
        const SizedBox(height: 20),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _stat(context, '20+', 'Years of\nTrust'),
              Container(width: 1, height: 40, color: colorScheme.outline.withOpacity(0.4), margin: const EdgeInsets.symmetric(horizontal: 16)),
              _stat(context, '15k+', 'Graduates'),
              Container(width: 1, height: 40, color: colorScheme.outline.withOpacity(0.4), margin: const EdgeInsets.symmetric(horizontal: 16)),
              _stat(context, '2004', 'Founded'),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: colorScheme.primary.withOpacity(0.6), blurRadius: 12, spreadRadius: 1),
                  ],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.spa_rounded, color: colorScheme.primary, size: 28),
              ).animate()
               .shimmer(duration: 2000.ms, color: Colors.white, size: 2),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _stat(BuildContext context, String val, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(children: [
      Text(val, style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
      const SizedBox(width: 8),
      Text(label, style: GoogleFonts.inter(fontSize: 10, color: colorScheme.onSurfaceVariant, height: 1.4)),
    ]);
  }

  Widget _buildCampusPreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/images/Image 2.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                cacheWidth: 1200,
              ),
            ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(children: [
        NeonGlassCard(
          neonColor: colorScheme.secondary,
          borderRadius: 20,
          padding: const EdgeInsets.all(22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.rocket_launch_outlined, color: colorScheme.secondary, size: 36),
            const SizedBox(height: 14),
            Text('Our Mission', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
            const SizedBox(height: 10),
            Text('To democratize high-end computer education by providing accessible, certified, and industry-relevant training to every aspiring professional in Mumbai and beyond. We don\'t just teach software; we build careers.',
                style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.65)),
            const SizedBox(height: 14),
            Wrap(spacing: 8, children: ['#Innovation', '#Accessibility', '#Empowerment']
                .map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
              ),
              child: Text(t, style: GoogleFonts.inter(fontSize: 10, color: colorScheme.secondary, fontWeight: FontWeight.w700)),
            )).toList()),
          ]),
        ),
        const SizedBox(height: 14),
        NeonGlassCard(
          neonColor: colorScheme.primary,
          borderRadius: 20,
          padding: const EdgeInsets.all(22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.visibility_outlined, color: colorScheme.primary, size: 36),
            const SizedBox(height: 14),
            Text('Our Vision', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
            const SizedBox(height: 10),
            Text('To be recognized as the premier hub for technological vocational training in India, fostering a generation of digital innovators.',
                style: GoogleFonts.inter(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.65)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPhilosophy(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = [
      {'icon': Icons.psychology_outlined, 'color': colorScheme.secondary,
        'title': 'Logical Core', 'desc': 'Prioritizing algorithmic thinking over rote memorization of syntax.'},
      {'icon': Icons.handyman_outlined, 'color': colorScheme.tertiary,
        'title': 'Project-First', 'desc': 'Real-world applications from day one to ensure practical readiness.'},
      {'icon': Icons.groups_outlined, 'color': colorScheme.primary,
        'title': 'Micro-Batches', 'desc': 'Ensuring personalized attention with strictly limited student counts.'},
      {'icon': Icons.verified_outlined, 'color': colorScheme.secondary,
        'title': 'Hybrid Certs', 'desc': 'Blending academic prestige with technical vocational skills.'},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('PHILOSOPHY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700,
            color: colorScheme.tertiary, letterSpacing: 3)),
        const SizedBox(height: 8),
        Text('How We Build Future Talent',
            style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: colorScheme.onSurface),
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.1,
          children: steps.map((s) => GlassCard(
            borderColor: (s['color'] as Color).withOpacity(0.3),
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: (s['color'] as Color).withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: (s['color'] as Color).withOpacity(0.3)),
                ),
                child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(s['title'] as String,
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
              const SizedBox(height: 6),
              Text(s['desc'] as String,
                  style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant, height: 1.4),
                  textAlign: TextAlign.center),
            ]),
          )).toList(),
        ),
      ]),
    );
  }

  Widget _buildAffiliations(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('STRATEGIC PARTNERSHIPS',
            style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF009688),
                letterSpacing: 2.5)),
        const SizedBox(height: 8),
        Text('Authorized Training Partners',
            style: GoogleFonts.sora(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface)),
        const SizedBox(height: 20),
        _partnerCard(
          context: context,
          logoPath: 'assets/images/ycmou-logo.webp',
          title: 'Yashwantrao Chavan Maharashtra Open University',
          subtitle: 'Authorized study center for degree and diploma programs with flexible learning schedules.',
          accentColor: const Color(0xFF009688),
        ),
        const SizedBox(height: 16),
        _partnerCard(
          context: context,
          logoPath: 'assets/images/mkcl-logo.webp',
          title: 'Maharashtra Knowledge Corporation Limited',
          subtitle: 'Official center for MS-CIT and KLiC certificate courses — the gold standard of IT literacy.',
          accentColor: const Color(0xFFFFC107),
        ),
      ]),
    );
  }

  Widget _partnerCard({
    required BuildContext context,
    required String logoPath,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return NeonGlassCard(
      neonColor: accentColor,
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      onTap: () {}, // Triggers shiny animation
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(logoPath, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final events = [
      {'year': '2004', 'color': colorScheme.secondary,
        'desc': 'The Foundation. SGCC opens its first lab in Bandra East with just 5 systems.'},
      {'year': '2010', 'color': colorScheme.primary,
        'desc': 'MKCL Partnership. Became an official MS-CIT center, empowering 2000+ students annually.'},
      {'year': '2018', 'color': colorScheme.tertiary,
        'desc': 'YCMOU Accreditation. Expanded into academic degrees and advanced professional certifications.'},
      {'year': '2026', 'color': colorScheme.secondary,
        'desc': 'The Digital Leap. Introduction of AI & Blockchain labs, keeping Mumbai\'s youth ahead of the curve.'},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('EVOLUTION', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700,
            color: colorScheme.tertiary, letterSpacing: 3)),
        const SizedBox(height: 8),
        Text('The Milestone Timeline',
            style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
        const SizedBox(height: 28),
        ...events.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          final isLeft = i % 2 == 0;
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (isLeft) Expanded(child: Align(alignment: Alignment.centerRight,
                child: _timelineItem(context, e['year'] as String, e['desc'] as String, e['color'] as Color, true))),
            Column(children: [
              Container(width: 2, height: i == 0 ? 20 : 40, color: colorScheme.outline.withOpacity(0.3)),
              Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: e['color'] as Color,
                  boxShadow: [BoxShadow(color: (e['color'] as Color).withOpacity(0.8), blurRadius: 10)],
                ),
              ),
              if (i < events.length - 1)
                Container(width: 2, height: 60, color: colorScheme.outline.withOpacity(0.3)),
            ]),
            if (!isLeft) Expanded(child: _timelineItem(context, e['year'] as String, e['desc'] as String, e['color'] as Color, false)),
            if (isLeft) const Expanded(child: SizedBox()),
          ]);
        }),
      ]),
    );
  }

  Widget _timelineItem(BuildContext context, String year, String desc, Color color, bool isRight) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: isRight ? const EdgeInsets.only(right: 16, bottom: 8) : const EdgeInsets.only(left: 16, bottom: 8),
      child: Column(crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
        Text(year, style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(desc, style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.5),
            textAlign: isRight ? TextAlign.right : TextAlign.left),
      ]),
    );
  }
}

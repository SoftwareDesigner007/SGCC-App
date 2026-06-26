import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';
import '../widgets/enquiry_modal.dart';
import '../widgets/app_footer.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  Future<void> _call() async {
    final uri = Uri.parse('tel:+918898919457');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _email() async {
    final uri = Uri.parse('mailto:sgccbandra@gmail.com');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _maps() async {
    final uri = Uri.parse('https://maps.app.goo.gl/Gwy1LikzX9Sw75N3A');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _whatsapp() async {
    final msg = Uri.encodeComponent('Hello SGCC! I have an enquiry.');
    final uri = Uri.parse('https://wa.me/918898919457?text=$msg');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareApp() async {
    await Share.share('Master the digital frontier with Mumbai\'s premier tech education hub! Join Shree Ganesh Computer Classes to ignite your skills and shape your future.\n\nVisit: https://sgcc.edu.in');
  }

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
            title: Text('Get In Touch',
                style: GoogleFonts.sora(fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
            bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: colorScheme.primary.withOpacity(0.2))),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                // Address card
                _infoCard(
                  color: colorScheme.secondary,
                  icon: Icons.location_on_outlined,
                  label: 'Campus Location',
                  title: 'Bandra East Campus',
                  subtitle: 'Church Of St. Joseph The Worker, B-9, next to Cardinal School, Subhash Nagar, Bandra East, Mumbai 400051',
                  onTap: _maps,
                  actionLabel: 'Open Maps',
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _infoCard(
                    color: colorScheme.primary,
                    icon: Icons.call_outlined,
                    label: 'Phone',
                    title: '+91 88989 19457',
                    subtitle: 'Mon–Sat, 9am–7pm',
                    onTap: _call,
                    actionLabel: 'Call Now',
                  )),
                  const SizedBox(width: 14),
                  Expanded(child: _infoCard(
                    color: colorScheme.tertiary,
                    icon: Icons.email_outlined,
                    label: 'Email',
                    title: 'sgccbandra@gmail.com',
                    subtitle: 'Response within 24hrs',
                    onTap: _email,
                    actionLabel: 'Send Email',
                  )),
                ]),
                const SizedBox(height: 14),
                // Timing
                const _BusinessHoursCard(),
                const SizedBox(height: 24),
                // Quick Enquiry Form
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('Quick ', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                        Text('Enquiry', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.secondary)),
                      ]),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameCtrl,
                        style: GoogleFonts.inter(color: colorScheme.onSurface),
                        decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                        validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.inter(color: colorScheme.onSurface),
                        decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _msgCtrl,
                        maxLines: 3,
                        style: GoogleFonts.inter(color: colorScheme.onSurface),
                        decoration: const InputDecoration(labelText: 'Message', prefixIcon: Icon(Icons.chat_bubble_outline)),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showEnquiryModal(context);
                            }
                          },
                          icon: const Icon(Icons.send_outlined, size: 18),
                          label: Text('Send Enquiry', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _whatsapp,
                          icon: const Icon(Icons.chat, size: 18),
                          label: Text('WhatsApp Us', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.secondary,
                            side: BorderSide(color: colorScheme.secondary.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                // Social
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Join the community', style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text('Stay updated with tech trends & campus news',
                          style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _socialBtn(Icons.share_outlined, colorScheme.primary, _shareApp),
                          _socialBtn(FontAwesomeIcons.facebookF, const Color(0xFF1877F2), () => _launchURL('https://facebook.com')),
                          _socialBtn(FontAwesomeIcons.instagram, const Color(0xFFE4405F), () => _launchURL('https://instagram.com')),
                          _socialBtn(FontAwesomeIcons.telegram, const Color(0xFF0088cc), () => _launchURL('https://telegram.org')),
                          _socialBtn(FontAwesomeIcons.discord, const Color(0xFF5865F2), () => _launchURL('https://discord.com')),
                          _socialBtn(FontAwesomeIcons.xTwitter, colorScheme.onSurface, () => _launchURL('https://twitter.com')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        
          const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
    );
  }

  Widget _infoCard({
    required Color color, required IconData icon, required String label,
    required String title, required String subtitle,
    required VoidCallback onTap, required String actionLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700,
              color: color, letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant, height: 1.4)),
          const SizedBox(height: 10),
          Row(children: [
            Text(actionLabel, style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: color, size: 14),
          ]),
        ]),
      ),
    );
  }

  Widget _socialBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _BusinessHoursCard extends StatelessWidget {
  const _BusinessHoursCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainerHigh
            : AppColors.lightSurfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_outlined, color: colorScheme.secondary, size: 20),
              const SizedBox(width: 10),
              Text(
                'Classes Timing',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimingRow(context, 'Monday – Friday', '08:00 AM – 10:00 PM'),
          _buildTimingRow(context, 'Saturday', '10:00 AM – 08:00 PM'),
          _buildTimingRow(context, 'Sunday', 'Closed', isClosed: true),
        ],
      ),
    );
  }

  Widget _buildTimingRow(BuildContext context, String day, String hours,
      {bool isClosed = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            hours,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isClosed ? colorScheme.error : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}


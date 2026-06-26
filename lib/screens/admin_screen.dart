import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _authenticated = false;
  final _pinCtrl = TextEditingController();
  static const _pin = '1234';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Admin Panel', style: GoogleFonts.sora(fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: colorScheme.tertiary.withOpacity(0.3))),
      ),
      body: _authenticated ? _buildDashboard() : _buildPinScreen(),
    );
  }

  Widget _buildPinScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.tertiary.withOpacity(0.4)),
          ),
          child: Icon(Icons.admin_panel_settings_outlined, color: colorScheme.tertiary, size: 40),
        ),
        const SizedBox(height: 24),
        Text('Admin Access', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
        const SizedBox(height: 8),
        Text('Enter your PIN to continue', style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 32),
        TextField(
          controller: _pinCtrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          style: GoogleFonts.sora(fontSize: 24, letterSpacing: 8, color: colorScheme.onSurface),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterText: '',
            hintText: '• • • •',
            hintStyle: GoogleFonts.sora(fontSize: 20, color: colorScheme.onSurfaceVariant.withOpacity(0.4)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.tertiary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_pinCtrl.text == _pin) {
                setState(() => _authenticated = true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Incorrect PIN', style: GoogleFonts.inter()),
                      backgroundColor: colorScheme.error),
                );
                _pinCtrl.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('UNLOCK', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ),
        ),
        const SizedBox(height: 16),
        Text('Default PIN: 1234', style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant)),
      ]),
    );
  }

  Widget _buildDashboard() {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final stats = [
      {'label': 'Total Courses', 'value': '15', 'icon': Icons.school_outlined, 'color': colorScheme.secondary},
      {'label': 'Enquiries Today', 'value': '8', 'icon': Icons.inbox_outlined, 'color': colorScheme.primary},
      {'label': 'Resources', 'value': '10', 'icon': Icons.folder_outlined, 'color': colorScheme.tertiary},
      {'label': 'Active Batches', 'value': '12', 'icon': Icons.groups_outlined, 'color': colorScheme.secondary},
    ];

    final actions = [
      {'icon': Icons.add_circle_outline, 'label': 'Add Course', 'color': colorScheme.primary},
      {'icon': Icons.edit_outlined, 'label': 'Edit Courses', 'color': colorScheme.secondary},
      {'icon': Icons.upload_file_outlined, 'label': 'Add Resource', 'color': colorScheme.tertiary},
      {'icon': Icons.notifications_outlined, 'label': 'Send Notice', 'color': colorScheme.primary},
      {'icon': Icons.bar_chart_outlined, 'label': 'View Stats', 'color': colorScheme.secondary},
      {'icon': Icons.settings_outlined, 'label': 'Settings', 'color': colorScheme.tertiary},
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Welcome
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.tertiary.withOpacity(0.15), colorScheme.secondary.withOpacity(0.08)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colorScheme.tertiary.withOpacity(0.3)),
          ),
          child: Row(children: [
            Icon(Icons.waving_hand, color: colorScheme.tertiary, size: 28),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome, Admin!', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
              Text('SGCC Management Panel', style: GoogleFonts.inter(fontSize: 12, color: colorScheme.onSurfaceVariant)),
            ]),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _authenticated = false),
              child: Text('Logout', style: GoogleFonts.sora(fontSize: 12, color: colorScheme.error)),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        Text('Overview', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
        const SizedBox(height: 14),
        // Stats grid
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
          children: stats.map((s) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (s['color'] as Color).withOpacity(0.3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(s['icon'] as IconData, color: s['color'] as Color, size: 24),
              const Spacer(),
              Text(s['value'] as String, style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
              Text(s['label'] as String, style: GoogleFonts.inter(fontSize: 11, color: colorScheme.onSurfaceVariant)),
            ]),
          )).toList(),
        ),
        const SizedBox(height: 24),
        Text('Quick Actions', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 3, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.0,
          children: actions.map((a) => GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${a['label']} — Coming soon!', style: GoogleFonts.inter()),
                  backgroundColor: isDark ? AppColors.darkSurfaceContainerHigh : AppColors.lightSurfaceContainerHigh,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (a['color'] as Color).withOpacity(0.25)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(a['icon'] as IconData, color: a['color'] as Color, size: 28),
                const SizedBox(height: 8),
                Text(a['label'] as String,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    textAlign: TextAlign.center, maxLines: 2),
              ]),
            ),
          )).toList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

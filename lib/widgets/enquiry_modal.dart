import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course_model.dart';
import '../theme/app_colors.dart';

void showEnquiryModal(BuildContext context, {String? preselectedCourse}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EnquiryModal(preselectedCourse: preselectedCourse),
  );
}

class EnquiryModal extends StatefulWidget {
  final String? preselectedCourse;
  const EnquiryModal({super.key, this.preselectedCourse});

  @override
  State<EnquiryModal> createState() => _EnquiryModalState();
}

class _EnquiryModalState extends State<EnquiryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String? _selectedCourse;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.preselectedCourse;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Open Google Form with pre-filled values
    final Uri googleFormUri = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSfHRBj5oj3v0EeX4cvOCfjl-lw6LnjI0Rp-eT_I3WgO0zg0dA/viewform'
      '?entry.name=${Uri.encodeComponent(_nameCtrl.text)}'
      '&entry.email=${Uri.encodeComponent(_emailCtrl.text)}',
    );

    // Also offer WhatsApp
    final String whatsappMsg = Uri.encodeComponent(
      'Hello SGCC! My name is ${_nameCtrl.text}.\n'
      'I am interested in: ${_selectedCourse ?? "a course"}.\n'
      '${_messageCtrl.text.isNotEmpty ? "Message: ${_messageCtrl.text}" : ""}',
    );
    final Uri whatsappUri = Uri.parse('https://wa.me/918898919457?text=$whatsappMsg');

    setState(() => _submitted = true);

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(googleFormUri)) {
      await launchUrl(googleFormUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: colorScheme.primary.withOpacity(0.4), width: 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: controller,
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.school_outlined,
                          color: colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Enquiry',
                            style: GoogleFonts.sora(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Offline Campus Only • Bandra East',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_submitted) ...[
                  _buildSuccessView(),
                ] else ...[
                  _buildField('Full Name', _nameCtrl, Icons.person_outline,
                      validator: (v) => v!.trim().isEmpty ? 'Name is required' : null),
                  const SizedBox(height: 16),
                  _buildField('Email Address', _emailCtrl, Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          !v!.contains('@') ? 'Enter a valid email' : null),
                  const SizedBox(height: 16),
                  // Course dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.darkSurfaceContainerHigh 
                          : AppColors.lightSurfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCourse,
                        hint: Text('Select a course',
                            style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant.withOpacity(0.5))),
                        dropdownColor: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.darkSurfaceContainerHigh 
                            : AppColors.lightSurfaceContainerHigh,
                        isExpanded: true,
                        icon: Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant),
                        style: GoogleFonts.inter(color: colorScheme.onSurface, fontSize: 14),
                        items: allCourses
                            .map((c) => DropdownMenuItem(
                                  value: c.name,
                                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCourse = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildField('Message (optional)', _messageCtrl,
                      Icons.chat_bubble_outline,
                      maxLines: 3, required: false),
                  const SizedBox(height: 28),
                  // Submit button
                  GestureDetector(
                    onTap: _submit,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        'SEND ENQUIRY VIA WHATSAPP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Call directly
                  OutlinedButton.icon(
                    onPressed: () async {
                      final Uri tel = Uri.parse('tel:+918898919457');
                      if (await canLaunchUrl(tel)) launchUrl(tel);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: colorScheme.secondary.withOpacity(0.5)),
                      foregroundColor: colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: Text(
                      'CALL US DIRECTLY',
                      style: GoogleFonts.sora(
                          fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    IconData prefixIcon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool required = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(color: colorScheme.onSurface, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: colorScheme.onSurfaceVariant, size: 20),
      ),
    );
  }

  Widget _buildSuccessView() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.secondary.withOpacity(0.4)),
            ),
            child: Icon(Icons.check_circle_outline,
                color: colorScheme.secondary, size: 40),
          ),
          const SizedBox(height: 20),
          Text('Enquiry Sent!',
              style: GoogleFonts.sora(
                  fontSize: 22, fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('We\'ll get back to you within 24 hours.',
              style: GoogleFonts.inter(
                  fontSize: 14, color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

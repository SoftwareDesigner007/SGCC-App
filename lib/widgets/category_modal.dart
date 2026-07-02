import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category_model.dart';

void showCategoryModal(BuildContext context, CategoryModel category) {
  showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CategoryModal(category: category),
  );
}

class CategoryModal extends StatelessWidget {
  final CategoryModel category;

  const CategoryModal({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
              // Icon + title + close
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
                    onPressed: () => Navigator.pop(context),
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
            ],
          ),
        );
      },
    );
  }
}

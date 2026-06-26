import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool outlined;
  final double? width;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.outlined = false,
    this.width,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final c = widget.color ?? colorScheme.primary;
    final tc = widget.textColor ?? colorScheme.onPrimary;

    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: _isPressed ? 0.96 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: widget.outlined ? Colors.transparent : c,
              borderRadius: BorderRadius.circular(12),
              border: widget.outlined ? Border.all(color: c, width: 1.5) : null,
              boxShadow: widget.outlined
                  ? null
                  : [
                      BoxShadow(
                        color: c.withOpacity(_isPressed ? 0.2 : 0.35),
                        blurRadius: _isPressed ? 12 : 20,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.outlined ? c : tc, size: 18),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.label.toUpperCase(),
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.outlined ? c : tc,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

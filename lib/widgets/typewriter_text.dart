import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typeSpeed;
  final Duration deleteSpeed;
  final Duration pauseDuration;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.typeSpeed = const Duration(milliseconds: 150),
    this.deleteSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> with SingleTickerProviderStateMixin {
  String _currentText = "";
  int _currentIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _startAnimation();
  }

  void _startAnimation() {
    final fullText = widget.texts[_currentIndex];
    
    if (_isDeleting) {
      if (_currentText.isEmpty) {
        setState(() {
          _isDeleting = false;
          _currentIndex = (_currentIndex + 1) % widget.texts.length;
        });
        _timer = Timer(const Duration(milliseconds: 500), _startAnimation);
      } else {
        setState(() {
          _currentText = _currentText.substring(0, _currentText.length - 1);
        });
        _timer = Timer(widget.deleteSpeed, _startAnimation);
      }
    } else {
      if (_currentText.length == fullText.length) {
        _timer = Timer(widget.pauseDuration, () {
          if (mounted) {
            setState(() {
              _isDeleting = true;
            });
            _startAnimation();
          }
        });
      } else {
        setState(() {
          _currentText = fullText.substring(0, _currentText.length + 1);
        });
        _timer = Timer(widget.typeSpeed, _startAnimation);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _currentText,
          style: widget.style,
        ),
        FadeTransition(
          opacity: _cursorController,
          child: Text(
            '|',
            style: widget.style?.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

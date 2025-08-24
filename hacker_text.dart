import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HackerText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;
  final bool resetOnChange;
  final Color glitchColor;
  final bool enableRandomChars;

  const HackerText({
    super.key,
    required this.text,
    required this.style,
    this.speed = const Duration(milliseconds: 45),
    this.resetOnChange = true,
    this.glitchColor = Colors.greenAccent,
    this.enableRandomChars = true,
  });

  @override
  State<HackerText> createState() => _HackerTextState();
}

class _HackerTextState extends State<HackerText> {
  String _shown = "";
  int _i = 0;
  Timer? _t;
  final _random = Random();
  
  // Cyberpunk character set for random generation
  static const String _cyberChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?`~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  static const String _hackChars = '01█▓▒░▄▀▌▐';

  @override
  void didUpdateWidget(covariant HackerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.resetOnChange) {
      _restart();
    }
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  String _getRandomChar() {
    if (!widget.enableRandomChars) return '';
    
    // Mix of normal chars and hacker chars
    final useHackChar = _random.nextDouble() < 0.3;
    final chars = useHackChar ? _hackChars : _cyberChars;
    return chars[_random.nextInt(chars.length)];
  }

  void _start() {
    _t?.cancel();
    _i = 0;
    _shown = "";
    
    _t = Timer.periodic(widget.speed, (timer) {
      if (_i >= widget.text.length) {
        timer.cancel();
      } else {
        setState(() {
          // Add some random characters before revealing the actual character
          if (_random.nextDouble() < 0.15 && widget.enableRandomChars) {
            _shown = _shown.substring(0, _shown.length > 0 ? _shown.length - 1 : 0) + 
                     _getRandomChar() + widget.text[_i];
          } else {
            _shown += widget.text[_i++];
          }
        });
      }
    });
  }

  void _restart() {
    _t?.cancel();
    _start();
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.glitchColor.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        _shown,
        style: widget.style.copyWith(
          shadows: [
            Shadow(
              color: widget.glitchColor.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
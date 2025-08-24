import 'dart:math';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration period;
  final bool enableNoise;
  final bool isReadable; // New parameter for question readability

  const GlitchText({
    super.key,
    required this.text,
    required this.style,
    this.period = const Duration(milliseconds: 1200),
    this.enableNoise = true,
    this.isReadable = false, // Default to false for backward compatibility
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: widget.period,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _addNoise(String text) {
    // If readable mode is on, reduce noise significantly
    if (!widget.enableNoise || widget.isReadable) return text;
    
    final noiseChars = ['█', '▓', '▒', '░', '▄', '▀', '▌', '▐'];
    final shouldAddNoise = _random.nextDouble() < 0.08; // Reduced from 0.15
    
    if (!shouldAddNoise) return text;
    
    final chars = text.split('');
    final noiseCount = (_random.nextDouble() * 1.5).round(); // Reduced from 3
    
    for (int i = 0; i < noiseCount; i++) {
      final pos = _random.nextInt(chars.length);
      final shouldReplace = _random.nextDouble() < 0.3; // Reduced from 0.7
      
      if (shouldReplace) {
        chars[pos] = noiseChars[_random.nextInt(noiseChars.length)];
      }
    }
    
    return chars.join('');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // Reduce glitch frequency for readable text
        final glitchChance = widget.isReadable ? 0.05 : 0.2;
        final shouldGlitch = _random.nextDouble() < glitchChance;
        
        // Reduce intensity for readable text
        final maxIntensity = widget.isReadable ? 1.5 : 3.0;
        final intensity = shouldGlitch ? (_random.nextDouble() * maxIntensity + 0.5) : 0.3;
        
        // Reduce offset ranges for readable text
        final maxOffset = widget.isReadable ? 1.5 : 4.0;
        final redOffset = shouldGlitch ? (_random.nextDouble() * maxOffset - maxOffset/2) : 0.1;
        final blueOffset = shouldGlitch ? (_random.nextDouble() * maxOffset - maxOffset/2) : -0.1;
        final greenOffset = shouldGlitch ? (_random.nextDouble() * 1.0 - 0.5) : 0.0;
        
        // Reduce skew for readable text
        final maxSkewX = widget.isReadable ? 0.02 : 0.1;
        final maxSkewY = widget.isReadable ? 0.005 : 0.02;
        final skewX = shouldGlitch ? (_random.nextDouble() * maxSkewX - maxSkewX/2) : 0.0;
        final skewY = shouldGlitch ? (_random.nextDouble() * maxSkewY - maxSkewY/2) : 0.0;
        
        final displayText = _addNoise(widget.text);
        
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(0, 1, skewX)
            ..setEntry(1, 0, skewY),
          child: Stack(
            children: [
              // Base text - always visible and clear
              Text(
                widget.text, // Use original text for base layer to ensure readability
                style: widget.style,
              ),
              
              // Red chromatic aberration - reduced opacity for readable text
              Transform.translate(
                offset: Offset(redOffset, 0),
                child: Text(
                  widget.isReadable ? widget.text : displayText,
                  style: widget.style.copyWith(
                    color: Colors.redAccent.withOpacity(
                      (widget.isReadable ? 0.3 : 0.6) * intensity
                    ),
                    shadows: shouldGlitch && !widget.isReadable ? [
                      Shadow(
                        color: Colors.redAccent.withOpacity(0.8),
                        blurRadius: 2,
                        offset: const Offset(1, 0),
                      ),
                    ] : null,
                  ),
                ),
              ),
              
              // Blue chromatic aberration - reduced opacity for readable text
              Transform.translate(
                offset: Offset(blueOffset, 0),
                child: Text(
                  widget.isReadable ? widget.text : displayText,
                  style: widget.style.copyWith(
                    color: Colors.cyanAccent.withOpacity(
                      (widget.isReadable ? 0.4 : 0.7) * intensity
                    ),
                    shadows: shouldGlitch && !widget.isReadable ? [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 3,
                        offset: const Offset(-1, 0),
                      ),
                    ] : null,
                  ),
                ),
              ),
              
              // Green chromatic aberration - only for non-readable text
              if (shouldGlitch && !widget.isReadable)
                Transform.translate(
                  offset: Offset(greenOffset, 0.5),
                  child: Text(
                    displayText,
                    style: widget.style.copyWith(
                      color: Colors.greenAccent.withOpacity(0.3 * intensity),
                    ),
                  ),
                ),
              
              // Flicker overlay - disabled for readable text
              if (shouldGlitch && _random.nextDouble() < 0.2 && !widget.isReadable)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                        Colors.white.withOpacity(0.05),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Text(
                    displayText,
                    style: widget.style.copyWith(
                      color: Colors.transparent,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
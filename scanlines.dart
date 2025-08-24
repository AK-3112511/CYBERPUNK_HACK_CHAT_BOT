import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Scanlines extends StatefulWidget {
  final double opacity;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableMatrix;
  final bool enableFlicker;

  const Scanlines({
    super.key,
    this.opacity = 0.15,
    this.primaryColor = Colors.cyanAccent,
    this.secondaryColor = Colors.greenAccent,
    this.enableMatrix = true,
    this.enableFlicker = true,
  });

  @override
  State<Scanlines> createState() => _ScanlinesState();
}

class _ScanlinesState extends State<Scanlines>
    with TickerProviderStateMixin {
  late final AnimationController _scanController;
  late final AnimationController _matrixController;
  late final AnimationController _flickerController;
  
  final _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Main scanline animation
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    // Matrix effect animation
    _matrixController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    
    // Flicker effect
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _matrixController.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([_scanController, _matrixController, _flickerController]),
        builder: (_, __) {
          return CustomPaint(
            painter: _CyberpunkScanlinePainter(
              scanProgress: _scanController.value,
              matrixProgress: _matrixController.value,
              flickerValue: widget.enableFlicker ? _flickerController.value : 0.0,
              opacity: widget.opacity,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              enableMatrix: widget.enableMatrix,
              random: _random,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _CyberpunkScanlinePainter extends CustomPainter {
  final double scanProgress;
  final double matrixProgress;
  final double flickerValue;
  final double opacity;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableMatrix;
  final Random random;

  _CyberpunkScanlinePainter({
    required this.scanProgress,
    required this.matrixProgress,
    required this.flickerValue,
    required this.opacity,
    required this.primaryColor,
    required this.secondaryColor,
    required this.enableMatrix,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base scanlines
    _drawScanlines(canvas, size);
    
    // Matrix effect
    if (enableMatrix) {
      _drawMatrixEffect(canvas, size);
    }
    
    // Cyberpunk grid overlay
    _drawCyberpunkGrid(canvas, size);
    
    // Enhanced vignette with cyberpunk colors
    _drawCyberpunkVignette(canvas, size);
    
    // Random flicker bars
    _drawFlickerBars(canvas, size);
  }

  void _drawScanlines(Canvas canvas, Size size) {
    final paint = Paint();
    final gap = 2.5;
    final offset = scanProgress * gap;

    for (double y = -offset; y < size.height; y += gap) {
      // Alternate between primary and secondary colors
      final useSecondary = ((y / gap) % 4) == 0;
      paint.color = (useSecondary ? secondaryColor : primaryColor)
          .withOpacity(opacity * (0.8 + 0.4 * sin(y * 0.01)));
      
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 0.8), paint);
    }
  }

  void _drawMatrixEffect(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(opacity * 0.3);
    
    final columns = (size.width / 20).floor();
    
    for (int i = 0; i < columns; i++) {
      final x = i * 20.0;
      final progress = (matrixProgress + i * 0.1) % 1.0;
      final y = progress * size.height;
      
      // Draw vertical "data streams"
      canvas.drawRect(
        Rect.fromLTWH(x, y - 50, 2, 50),
        paint,
      );
    }
  }

  void _drawCyberpunkGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = secondaryColor.withOpacity(opacity * 0.1)
      ..strokeWidth = 0.5;

    // Horizontal grid lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Vertical grid lines
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  void _drawCyberpunkVignette(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Outer vignette
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          primaryColor.withOpacity(0.1),
          Colors.black.withOpacity(0.3),
        ],
        stops: const [0.6, 0.8, 1.0],
      ).createShader(center & size);
    
    canvas.drawRect(Offset.zero & size, vignettePaint);
    
    // Inner glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          secondaryColor.withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4],
      ).createShader(center & size);
    
    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  void _drawFlickerBars(Canvas canvas, Size size) {
    if (random.nextDouble() < 0.95) return; // Only flicker occasionally
    
    final paint = Paint()
      ..color = primaryColor.withOpacity(opacity * flickerValue * 0.5);
    
    final barCount = random.nextInt(3) + 1;
    
    for (int i = 0; i < barCount; i++) {
      final y = random.nextDouble() * size.height;
      final height = random.nextDouble() * 5 + 1;
      
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CyberpunkScanlinePainter oldDelegate) =>
      oldDelegate.scanProgress != scanProgress ||
      oldDelegate.matrixProgress != matrixProgress ||
      oldDelegate.flickerValue != flickerValue ||
      oldDelegate.opacity != opacity;
}
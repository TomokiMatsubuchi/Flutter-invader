import 'package:flutter/material.dart';
import 'dart:math';

class PixelPlayButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(4, 4)
      ..lineTo(4, 16)
      ..lineTo(16, 10)
      ..close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PixelPlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final pixelSize = 2.0;
    
    final playPattern = [
      [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    ];
    
    for (int row = 0; row < playPattern.length; row++) {
      for (int col = 0; col < playPattern[row].length; col++) {
        if (playPattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * pixelSize,
              row * pixelSize,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PixelPauseIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final pixelSize = 2.0;
    
    final pausePattern = [
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0],
    ];
    
    for (int row = 0; row < pausePattern.length; row++) {
      for (int col = 0; col < pausePattern[row].length; col++) {
        if (pausePattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * pixelSize,
              row * pixelSize,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PixelSpaceshipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final pixelSize = 8.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    final spaceshipPattern = [
      [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0],
      [0, 0, 0, 1, 2, 2, 3, 3, 3, 2, 2, 1, 0, 0, 0],
      [0, 0, 1, 2, 2, 3, 3, 4, 3, 3, 2, 2, 1, 0, 0],
      [0, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 0],
      [1, 2, 2, 3, 3, 4, 4, 5, 4, 4, 3, 3, 2, 2, 1],
      [1, 2, 3, 3, 4, 4, 5, 5, 5, 4, 4, 3, 3, 2, 1],
      [2, 2, 3, 4, 4, 5, 5, 6, 5, 5, 4, 4, 3, 2, 2],
      [2, 3, 3, 4, 5, 5, 6, 6, 6, 5, 5, 4, 3, 3, 2],
      [3, 3, 4, 4, 5, 6, 6, 7, 6, 6, 5, 4, 4, 3, 3],
    ];
    
    final colors = [
      Colors.transparent,
      Colors.grey[800]!,
      Colors.grey[600]!,
      Colors.blue[800]!,
      Colors.blue[600]!,
      Colors.blue[400]!,
      Colors.cyan[400]!,
      Colors.white,
    ];
    
    for (int row = 0; row < spaceshipPattern.length; row++) {
      for (int col = 0; col < spaceshipPattern[row].length; col++) {
        final colorIndex = spaceshipPattern[row][col];
        if (colorIndex > 0) {
          paint.color = colors[colorIndex];
          
          final x = centerX - (spaceshipPattern[row].length * pixelSize / 2) + (col * pixelSize);
          final y = centerY - (spaceshipPattern.length * pixelSize / 2) + (row * pixelSize);
          
          canvas.drawRect(
            Rect.fromLTWH(x, y, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarFieldPainter extends CustomPainter {
  final double animationValue;
  
  StarFieldPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final random = Random(42);
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final twinkle = (sin((animationValue * 2 * pi) + (i * 0.1)) + 1) / 2;
      
      paint.color = Colors.white.withOpacity(twinkle * 0.8);
      
      canvas.drawCircle(
        Offset(x, y),
        random.nextDouble() * 2 + 0.5,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
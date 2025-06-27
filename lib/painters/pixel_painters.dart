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

// SF戦闘機ペインター（プレイヤー用）
class SFFighterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 40x40のピクセルパターン（縮小版）
    final fighterPattern = [
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 1, 2, 2, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 2, 3, 3, 2, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 0, 0, 0],
      [0, 0, 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 0, 0],
      [0, 0, 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 0, 0],
      [0, 1, 2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2, 1, 0],
      [1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1],
      [2, 3, 4, 5, 6, 7, 8, 8, 8, 8, 7, 6, 5, 4, 3, 2],
      [1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1],
      [0, 1, 2, 3, 4, 5, 5, 5, 5, 5, 5, 4, 3, 2, 1, 0],
      [0, 0, 1, 2, 2, 3, 3, 3, 3, 3, 3, 2, 2, 1, 0, 0],
      [0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    ];
    
    final colors = [
      Colors.transparent,           // 0
      Color(0xFF1E3A8A),           // 1 - ダークブルー
      Color(0xFF3B82F6),           // 2 - ブルー
      Color(0xFF60A5FA),           // 3 - ライトブルー
      Color(0xFF93C5FD),           // 4 - ペールブルー
      Color(0xFF00D4AA),           // 5 - シアン
      Color(0xFF06FFA5),           // 6 - ネオンシアン
      Color(0xFFFFFFFF),           // 7 - ホワイト
      Color(0xFF00FFFF),           // 8 - エレクトリックシアン
    ];
    
    final pixelSize = size.width / 16;
    
    for (int row = 0; row < fighterPattern.length; row++) {
      for (int col = 0; col < fighterPattern[row].length; col++) {
        final colorIndex = fighterPattern[row][col];
        if (colorIndex > 0) {
          paint.color = colors[colorIndex];
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

// エイリアン侵略機ペインター（敵用）
class AlienInvaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 30x30のエイリアン船パターン
    final alienPattern = [
      [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0],
      [0, 1, 2, 2, 3, 3, 4, 4, 3, 3, 2, 2, 1, 0],
      [1, 2, 3, 3, 4, 5, 5, 5, 5, 4, 3, 3, 2, 1],
      [2, 3, 4, 4, 5, 6, 6, 6, 6, 5, 4, 4, 3, 2],
      [3, 4, 5, 5, 6, 7, 7, 7, 7, 6, 5, 5, 4, 3],
      [4, 5, 6, 6, 7, 8, 8, 8, 8, 7, 6, 6, 5, 4],
      [3, 4, 5, 5, 6, 7, 7, 7, 7, 6, 5, 5, 4, 3],
      [2, 3, 4, 4, 5, 6, 6, 6, 6, 5, 4, 4, 3, 2],
      [1, 2, 3, 3, 4, 5, 5, 5, 5, 4, 3, 3, 2, 1],
      [0, 1, 2, 2, 3, 3, 4, 4, 3, 3, 2, 2, 1, 0],
      [0, 0, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0],
    ];
    
    final colors = [
      Colors.transparent,           // 0
      Color(0xFF7F1D1D),           // 1 - ダークレッド
      Color(0xFFDC2626),           // 2 - レッド
      Color(0xFFEF4444),           // 3 - ライトレッド
      Color(0xFFFF6B35),           // 4 - オレンジレッド
      Color(0xFFFF8500),           // 5 - オレンジ
      Color(0xFFFFA500),           // 6 - ゴールドオレンジ
      Color(0xFFFFD700),           // 7 - ゴールド
      Color(0xFFFFFFFF),           // 8 - ホワイト
    ];
    
    final pixelSize = size.width / 14;
    
    for (int row = 0; row < alienPattern.length; row++) {
      for (int col = 0; col < alienPattern[row].length; col++) {
        final colorIndex = alienPattern[row][col];
        if (colorIndex > 0) {
          paint.color = colors[colorIndex];
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

// プラズマ弾ペインター（プレイヤー用）
class PlasmaBulletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // エネルギー弾のパターン
    final bulletPattern = [
      [0, 1, 1, 0],
      [1, 2, 2, 1],
      [1, 3, 3, 1],
      [1, 3, 3, 1],
      [1, 3, 3, 1],
      [1, 2, 2, 1],
      [0, 1, 1, 0],
    ];
    
    final colors = [
      Colors.transparent,           // 0
      Color(0xFF06FFA5),           // 1 - ネオンシアン
      Color(0xFF00FFFF),           // 2 - エレクトリックシアン
      Color(0xFFFFFFFF),           // 3 - ホワイト
    ];
    
    final pixelSize = size.width / 4;
    
    for (int row = 0; row < bulletPattern.length; row++) {
      for (int col = 0; col < bulletPattern[row].length; col++) {
        final colorIndex = bulletPattern[row][col];
        if (colorIndex > 0) {
          paint.color = colors[colorIndex];
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

// エイリアン弾ペインター（敵用）
class AlienBulletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // エイリアン武器のパターン
    final bulletPattern = [
      [0, 1, 1, 0],
      [1, 2, 2, 1],
      [2, 3, 3, 2],
      [2, 3, 3, 2],
      [2, 3, 3, 2],
      [1, 2, 2, 1],
      [0, 1, 1, 0],
    ];
    
    final colors = [
      Colors.transparent,           // 0
      Color(0xFF7F1D1D),           // 1 - ダークレッド
      Color(0xFFDC2626),           // 2 - レッド
      Color(0xFFFF6B35),           // 3 - オレンジレッド
    ];
    
    final pixelSize = size.width / 4;
    
    for (int row = 0; row < bulletPattern.length; row++) {
      for (int col = 0; col < bulletPattern[row].length; col++) {
        final colorIndex = bulletPattern[row][col];
        if (colorIndex > 0) {
          paint.color = colors[colorIndex];
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
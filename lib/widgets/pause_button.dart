import 'package:flutter/material.dart';
import '../painters/pixel_painters.dart';

class PauseButton extends StatelessWidget {
  final bool isPaused;
  final bool isGameOver;
  final VoidCallback onPressed;
  
  const PauseButton({
    super.key,
    required this.isPaused,
    this.isGameOver = false,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isGameOver 
              ? Colors.grey // ゲームオーバー時はグレー
              : (isPaused ? Colors.green : Colors.orange),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: isGameOver 
                  ? Colors.grey
                  : (isPaused ? Colors.green : Colors.orange),
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isGameOver ? null : onPressed, // ゲームオーバー時は無効化
            child: Container(
              padding: const EdgeInsets.all(8),
              child: CustomPaint(
                painter: isPaused ? PixelPlayIconPainter() : PixelPauseIconPainter(),
                size: const Size(24, 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
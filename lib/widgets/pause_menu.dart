import 'package:flutter/material.dart';
import 'pixel_button.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onGoToTitle;
  
  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onGoToTitle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.cyan, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan,
                offset: const Offset(6, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // タイトル
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Text(
                  'GAME PAUSED',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // レジューム ボタン
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PixelButton(
                  text: 'RESUME',
                  onPressed: onResume,
                  backgroundColor: Colors.green,
                  width: double.infinity,
                  height: 50,
                  icon: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
              ),
              
              // リスタート ボタン
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: PixelButton(
                  text: 'RESTART',
                  onPressed: onRestart,
                  backgroundColor: Colors.orange,
                  width: double.infinity,
                  height: 50,
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
                ),
              ),
              
              // タイトルに戻る ボタン
              PixelButton(
                text: 'TITLE',
                onPressed: onGoToTitle,
                backgroundColor: Colors.red,
                width: double.infinity,
                height: 50,
                icon: const Icon(Icons.home, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
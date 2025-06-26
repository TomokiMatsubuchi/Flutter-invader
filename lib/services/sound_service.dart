import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static bool _soundEnabled = true;
  
  static bool get soundEnabled => _soundEnabled;
  
  static void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }
  
  // システムサウンドを使用したシンプルな効果音
  static Future<void> playShootSound() async {
    if (!_soundEnabled) return;
    
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Error playing shoot sound: $e');
    }
  }
  
  static Future<void> playHitSound() async {
    if (!_soundEnabled) return;
    
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      debugPrint('Error playing hit sound: $e');
    }
  }
  
  static Future<void> playPlayerHitSound() async {
    if (!_soundEnabled) return;
    
    try {
      // プレイヤー被弾時は振動も併用
      await HapticFeedback.heavyImpact();
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      debugPrint('Error playing player hit sound: $e');
    }
  }
  
  static Future<void> playGameOverSound() async {
    if (!_soundEnabled) return;
    
    try {
      await HapticFeedback.vibrate();
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      debugPrint('Error playing game over sound: $e');
    }
  }
  
  static Future<void> playNewHighScoreSound() async {
    if (!_soundEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      debugPrint('Error playing new high score sound: $e');
    }
  }
  
  // ゲーム開始時の効果音
  static Future<void> playGameStartSound() async {
    if (!_soundEnabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Error playing game start sound: $e');
    }
  }
  
  // 軽いタッチフィードバック
  static Future<void> playButtonTapSound() async {
    if (!_soundEnabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Error playing button tap sound: $e');
    }
  }
}
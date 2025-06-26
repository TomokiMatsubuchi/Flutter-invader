import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class HighScoreService {
  static const String _highScoreKey = 'high_score';
  
  static Future<int> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting high score: $e');
      return 0;
    }
  }
  
  static Future<bool> saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHighScore = await getHighScore();
      
      if (score > currentHighScore) {
        await prefs.setInt(_highScoreKey, score);
        return true; // 新記録
      }
      return false; // 記録更新なし
    } catch (e) {
      debugPrint('Error saving high score: $e');
      return false;
    }
  }
  
  static Future<void> resetHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
    } catch (e) {
      debugPrint('Error resetting high score: $e');
    }
  }
}
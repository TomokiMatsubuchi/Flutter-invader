import 'package:flutter/material.dart';

class GameConstants {
  // ゲーム画面サイズ
  static const double gameWidth = 400.0;
  static const double gameHeight = 600.0;
  
  // ゲームタイミング
  static const int gameLoopDuration = 16; // milliseconds (60 FPS)
  static const int invaderMoveInterval = 30; // frames
  
  // ゲームバランス
  static const int maxBullets = 3;
  static const int scorePerInvader = 10;
  static const int playerLives = 3;
  static const double playerSpeed = 20.0;
  static const double bulletSpeed = 5.0;
  static const double invaderSpeed = 20.0;
  static const double invaderBulletSpeed = 3.0;
  
  // プレイヤー設定
  static const double playerWidth = 40.0;
  static const double playerHeight = 40.0;
  static const double playerY = gameHeight - 80;
  
  // インベーダー設定
  static const int invaderRows = 5;
  static const int invaderCols = 8;
  static const double invaderWidth = 30.0;
  static const double invaderHeight = 30.0;
  static const double invaderStartX = 40.0;
  static const double invaderStartY = 50.0;
  static const double invaderSpacing = 40.0;
  
  // 弾丸設定
  static const double bulletWidth = 4.0;
  static const double bulletHeight = 10.0;
}

class GameColors {
  static const backgroundColor = [
    Color(0xFF0F0F23),
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF000000),
  ];
}
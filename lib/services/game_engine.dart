import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/bullet.dart';
import '../models/invader.dart';
import '../models/invader_bullet.dart';
import '../utils/constants.dart';

class GameEngine {
  static void initializeInvaders(GameState gameState) {
    try {
      gameState.invaders.clear();
      // 初期化時はインベーダーを配置しない（ランダム出現システムに任せる）
    } catch (e) {
      debugPrint('Error initializing invaders: $e');
    }
  }
  
  static void spawnRandomInvader(GameState gameState) {
    try {
      // 一定確率でインベーダーを生成
      if (Random().nextInt(100) < 2) { // 2%の確率に増加（HPが増えたため）
        final spawnSide = Random().nextInt(3); // 0:上, 1:右, 2:左（下は除外）
        double x, y;
        
        switch (spawnSide) {
          case 0: // 上から
            x = Random().nextDouble() * (GameConstants.gameWidth - GameConstants.invaderWidth);
            y = -GameConstants.invaderHeight;
            break;
          case 1: // 右から
            x = GameConstants.gameWidth;
            y = Random().nextDouble() * (GameConstants.gameHeight - GameConstants.invaderHeight);
            break;
          case 2: // 左から
            x = -GameConstants.invaderWidth;
            y = Random().nextDouble() * (GameConstants.gameHeight - GameConstants.invaderHeight);
            break;
          default:
            x = Random().nextDouble() * (GameConstants.gameWidth - GameConstants.invaderWidth);
            y = -GameConstants.invaderHeight;
        }
        
        gameState.invaders.add(Invader(x: x, y: y));
      }
    } catch (e) {
      debugPrint('Error spawning random invader: $e');
    }
  }
  
  static void updateBullets(GameState gameState) {
    try {
      gameState.bullets.removeWhere((bullet) {
        bullet.y -= GameConstants.bulletSpeed;
        return bullet.y < 0;
      });
    } catch (e) {
      debugPrint('Error updating bullets: $e');
    }
  }
  
  static bool updateInvaders(GameState gameState) {
    if (gameState.invaders.isEmpty) return false;
    
    // フレームカウンターで移動頻度を調整
    final shouldMove = gameState.moveCounter % 3 == 0; // 3フレームに1回移動
    
    // インベーダーをプレイヤーに向かって移動させる
    gameState.invaders.removeWhere((invader) {
      if (shouldMove) {
        final playerCenterX = gameState.player.x + GameConstants.playerWidth / 2;
        final playerCenterY = gameState.player.y + GameConstants.playerHeight / 2;
        final invaderCenterX = invader.x + GameConstants.invaderWidth / 2;
        final invaderCenterY = invader.y + GameConstants.invaderHeight / 2;
        
        // プレイヤーとの距離を計算
        final dx = playerCenterX - invaderCenterX;
        final dy = playerCenterY - invaderCenterY;
        final distance = sqrt(dx * dx + dy * dy);
        
        // 一定距離以上離れている場合のみ移動
        if (distance > 5.0) {
          // 正規化した方向ベクトルを計算
          final normalizedDx = dx / distance;
          final normalizedDy = dy / distance;
          
          // インベーダーをプレイヤーに向かって滑らかに移動
          invader.x += normalizedDx * GameConstants.invaderSpeed;
          invader.y += normalizedDy * GameConstants.invaderSpeed;
        }
      }
      
      // 画面外に出たインベーダーを削除
      return invader.x < -GameConstants.invaderWidth || 
             invader.x > GameConstants.gameWidth || 
             invader.y < -GameConstants.invaderHeight || 
             invader.y > GameConstants.gameHeight;
    });
    
    return false; // 方向変更は不要
  }
  
  static int checkCollisions(GameState gameState) {
    int hitCount = 0;
    
    try {
      gameState.bullets.removeWhere((bullet) {
        for (int i = gameState.invaders.length - 1; i >= 0; i--) {
          var invader = gameState.invaders[i];
          if (bullet.x >= invader.x && 
              bullet.x <= invader.x + GameConstants.invaderWidth &&
              bullet.y >= invader.y && 
              bullet.y <= invader.y + GameConstants.invaderHeight) {
            gameState.invaders.removeAt(i);
            hitCount++;
            return true;
          }
        }
        return false;
      });
    } catch (e) {
      debugPrint('Error checking collisions: $e');
    }
    
    return hitCount;
  }
  
  static bool canFireBullet(GameState gameState) {
    return gameState.bullets.length < GameConstants.maxBullets;
  }
  
  static void fireBullet(GameState gameState) {
    try {
      if (canFireBullet(gameState)) {
        gameState.bullets.add(Bullet(
          x: gameState.player.x + GameConstants.playerWidth / 2,
          y: gameState.player.y,
        ));
      }
    } catch (e) {
      debugPrint('Error firing bullet: $e');
    }
  }
  
  static void updateInvaderBullets(GameState gameState) {
    try {
      gameState.invaderBullets.removeWhere((bullet) {
        bullet.y += GameConstants.invaderBulletSpeed;
        return bullet.y > GameConstants.gameHeight;
      });
    } catch (e) {
      debugPrint('Error updating invader bullets: $e');
    }
  }

  static void generateInvaderBullet(GameState gameState) {
    try {
      if (gameState.invaders.isNotEmpty && Random().nextInt(100) < 3) { // 3%に増加
        final randomInvader = gameState.invaders[Random().nextInt(gameState.invaders.length)];
        gameState.invaderBullets.add(InvaderBullet(
          x: randomInvader.x + GameConstants.invaderWidth / 2,
          y: randomInvader.y + GameConstants.invaderHeight,
        ));
      }
    } catch (e) {
      debugPrint('Error generating invader bullet: $e');
    }
  }

  static bool checkPlayerCollision(GameState gameState) {
    try {
      // インベーダーの弾丸との衝突判定
      for (int i = gameState.invaderBullets.length - 1; i >= 0; i--) {
        final bullet = gameState.invaderBullets[i];
        if (bullet.x >= gameState.player.x &&
            bullet.x <= gameState.player.x + GameConstants.playerWidth &&
            bullet.y >= gameState.player.y &&
            bullet.y <= gameState.player.y + GameConstants.playerHeight) {
          gameState.invaderBullets.removeAt(i);
          return true;
        }
      }
      
      // インベーダーとの直接接触判定
      for (int i = gameState.invaders.length - 1; i >= 0; i--) {
        final invader = gameState.invaders[i];
        if (invader.x < gameState.player.x + GameConstants.playerWidth &&
            invader.x + GameConstants.invaderWidth > gameState.player.x &&
            invader.y < gameState.player.y + GameConstants.playerHeight &&
            invader.y + GameConstants.invaderHeight > gameState.player.y) {
          gameState.invaders.removeAt(i);
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error checking player collision: $e');
    }
    return false;
  }

  static bool isGameOver(GameState gameState) {
    return gameState.lives <= 0; // インベーダーは無限出現するため、ライフのみでゲームオーバー判定
  }

  static bool isPlayerDead(GameState gameState) {
    return gameState.lives <= 0;
  }
}
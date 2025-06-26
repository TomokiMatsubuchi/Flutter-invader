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
      for (int row = 0; row < GameConstants.invaderRows; row++) {
        for (int col = 0; col < GameConstants.invaderCols; col++) {
          gameState.invaders.add(Invader(
            x: GameConstants.invaderStartX + col * GameConstants.invaderSpacing,
            y: GameConstants.invaderStartY + row * GameConstants.invaderSpacing,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error initializing invaders: $e');
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
    
    final newCounter = gameState.moveCounter + 1;
    bool directionChanged = false;
    
    if (newCounter % GameConstants.invaderMoveInterval == 0) {
      bool hitEdge = false;
      
      if (gameState.moveRight) {
        for (var invader in gameState.invaders) {
          invader.x += GameConstants.invaderSpeed;
          if (invader.x >= GameConstants.gameWidth - GameConstants.invaderWidth) {
            hitEdge = true;
          }
        }
      } else {
        for (var invader in gameState.invaders) {
          invader.x -= GameConstants.invaderSpeed;
          if (invader.x <= 0) {
            hitEdge = true;
          }
        }
      }
      
      if (hitEdge) {
        directionChanged = true;
        for (var invader in gameState.invaders) {
          invader.y += GameConstants.invaderSpeed;
        }
      }
    }
    
    return directionChanged;
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
      if (gameState.invaders.isNotEmpty && Random().nextInt(100) < 2) {
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
    } catch (e) {
      debugPrint('Error checking player collision: $e');
    }
    return false;
  }

  static bool isGameOver(GameState gameState) {
    return gameState.invaders.isEmpty || gameState.lives <= 0;
  }

  static bool isPlayerDead(GameState gameState) {
    return gameState.lives <= 0;
  }
}
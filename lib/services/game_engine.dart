import 'dart:async';
import '../models/game_state.dart';
import '../models/bullet.dart';
import '../models/invader.dart';
import '../utils/constants.dart';

class GameEngine {
  static void initializeInvaders(GameState gameState) {
    gameState.invaders.clear();
    for (int row = 0; row < GameConstants.invaderRows; row++) {
      for (int col = 0; col < GameConstants.invaderCols; col++) {
        gameState.invaders.add(Invader(
          x: GameConstants.invaderStartX + col * GameConstants.invaderSpacing,
          y: GameConstants.invaderStartY + row * GameConstants.invaderSpacing,
        ));
      }
    }
  }
  
  static void updateBullets(GameState gameState) {
    gameState.bullets.removeWhere((bullet) {
      bullet.y -= GameConstants.bulletSpeed;
      return bullet.y < 0;
    });
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
    
    return hitCount;
  }
  
  static bool canFireBullet(GameState gameState) {
    return gameState.bullets.length < GameConstants.maxBullets;
  }
  
  static void fireBullet(GameState gameState) {
    if (canFireBullet(gameState)) {
      gameState.bullets.add(Bullet(
        x: gameState.player.x + GameConstants.playerWidth / 2,
        y: gameState.player.y,
      ));
    }
  }
  
  static bool isGameOver(GameState gameState) {
    return gameState.invaders.isEmpty;
  }
}
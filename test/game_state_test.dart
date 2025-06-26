import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_invader/models/game_state.dart';
import 'package:flutter_invader/models/player.dart';
import 'package:flutter_invader/models/bullet.dart';
import 'package:flutter_invader/models/invader.dart';
import 'package:flutter_invader/models/invader_bullet.dart';

void main() {
  group('GameState Tests', () {
    test('GameState.initial() creates correct initial state', () {
      final gameState = GameState.initial();
      
      expect(gameState.player, isA<Player>());
      expect(gameState.bullets, isEmpty);
      expect(gameState.invaderBullets, isEmpty);
      expect(gameState.invaders, isEmpty);
      expect(gameState.score, equals(0));
      expect(gameState.highScore, equals(0));
      expect(gameState.lives, equals(3));
      expect(gameState.status, equals(GameStatus.playing));
      expect(gameState.moveRight, isTrue);
      expect(gameState.moveCounter, equals(0));
    });

    test('copyWith() creates new instance with updated values', () {
      final originalState = GameState.initial();
      final newBullets = [Bullet(x: 100, y: 200)];
      final newInvaderBullets = [InvaderBullet(x: 150, y: 250)];
      
      final newState = originalState.copyWith(
        bullets: newBullets,
        invaderBullets: newInvaderBullets,
        score: 100,
        highScore: 50,
        lives: 2,
        status: GameStatus.paused,
      );
      
      expect(newState.bullets, equals(newBullets));
      expect(newState.invaderBullets, equals(newInvaderBullets));
      expect(newState.score, equals(100));
      expect(newState.highScore, equals(50));
      expect(newState.lives, equals(2));
      expect(newState.status, equals(GameStatus.paused));
      expect(newState.player, equals(originalState.player));
      expect(newState.invaders, equals(originalState.invaders));
    });

    test('Status getter methods work correctly', () {
      final playingState = GameState.initial();
      expect(playingState.isPlaying, isTrue);
      expect(playingState.isPaused, isFalse);
      expect(playingState.isGameOver, isFalse);
      
      final pausedState = playingState.copyWith(status: GameStatus.paused);
      expect(pausedState.isPlaying, isFalse);
      expect(pausedState.isPaused, isTrue);
      expect(pausedState.isGameOver, isFalse);
      
      final gameOverState = playingState.copyWith(status: GameStatus.gameOver);
      expect(gameOverState.isPlaying, isFalse);
      expect(gameOverState.isPaused, isFalse);
      expect(gameOverState.isGameOver, isTrue);
    });
  });
}
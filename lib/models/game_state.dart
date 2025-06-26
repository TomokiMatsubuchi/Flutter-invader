import 'dart:async';
import 'bullet.dart';
import 'invader.dart';
import 'invader_bullet.dart';
import 'player.dart';
import '../utils/constants.dart';

enum GameStatus { playing, paused, gameOver }

class GameState {
  final Player player;
  final List<Bullet> bullets;
  final List<InvaderBullet> invaderBullets;
  final List<Invader> invaders;
  final int score;
  final int highScore;
  final int lives;
  final GameStatus status;
  final bool moveRight;
  final int moveCounter;
  Timer? gameTimer;
  
  GameState({
    required this.player,
    required this.bullets,
    required this.invaderBullets,
    required this.invaders,
    required this.score,
    required this.highScore,
    required this.lives,
    required this.status,
    required this.moveRight,
    required this.moveCounter,
    this.gameTimer,
  });
  
  factory GameState.initial({int highScore = 0}) {
    return GameState(
      player: Player(),
      bullets: [],
      invaderBullets: [],
      invaders: [],
      score: 0,
      highScore: highScore,
      lives: GameConstants.playerLives,
      status: GameStatus.playing,
      moveRight: true,
      moveCounter: 0,
    );
  }
  
  GameState copyWith({
    Player? player,
    List<Bullet>? bullets,
    List<InvaderBullet>? invaderBullets,
    List<Invader>? invaders,
    int? score,
    int? highScore,
    int? lives,
    GameStatus? status,
    bool? moveRight,
    int? moveCounter,
    Timer? gameTimer,
  }) {
    return GameState(
      player: player ?? this.player,
      bullets: bullets ?? List.from(this.bullets),
      invaderBullets: invaderBullets ?? List.from(this.invaderBullets),
      invaders: invaders ?? List.from(this.invaders),
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      moveRight: moveRight ?? this.moveRight,
      moveCounter: moveCounter ?? this.moveCounter,
      gameTimer: gameTimer ?? this.gameTimer,
    );
  }
  
  bool get isPaused => status == GameStatus.paused;
  bool get isGameOver => status == GameStatus.gameOver;
  bool get isPlaying => status == GameStatus.playing;
}
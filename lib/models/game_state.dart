import 'dart:async';
import 'bullet.dart';
import 'invader.dart';
import 'player.dart';

enum GameStatus { playing, paused, gameOver }

class GameState {
  final Player player;
  final List<Bullet> bullets;
  final List<Invader> invaders;
  final int score;
  final GameStatus status;
  final bool moveRight;
  final int moveCounter;
  Timer? gameTimer;
  
  GameState({
    required this.player,
    required this.bullets,
    required this.invaders,
    required this.score,
    required this.status,
    required this.moveRight,
    required this.moveCounter,
    this.gameTimer,
  });
  
  factory GameState.initial() {
    return GameState(
      player: Player(),
      bullets: [],
      invaders: [],
      score: 0,
      status: GameStatus.playing,
      moveRight: true,
      moveCounter: 0,
    );
  }
  
  GameState copyWith({
    Player? player,
    List<Bullet>? bullets,
    List<Invader>? invaders,
    int? score,
    GameStatus? status,
    bool? moveRight,
    int? moveCounter,
    Timer? gameTimer,
  }) {
    return GameState(
      player: player ?? this.player,
      bullets: bullets ?? List.from(this.bullets),
      invaders: invaders ?? List.from(this.invaders),
      score: score ?? this.score,
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
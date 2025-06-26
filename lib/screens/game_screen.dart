import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../models/bullet.dart';
import '../models/invader.dart';
import '../models/player.dart';
import '../services/game_engine.dart';
import '../utils/constants.dart';
import '../widgets/pause_button.dart';
import '../widgets/pause_menu.dart';
import 'title_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _gameState;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _gameState = GameState.initial();
    GameEngine.initializeInvaders(_gameState);
    
    _gameState.gameTimer = Timer.periodic(
      Duration(milliseconds: GameConstants.gameLoopDuration), 
      _gameLoop,
    );
  }

  void _gameLoop(Timer timer) {
    if (_gameState.isPaused || _gameState.isGameOver) return;
    
    setState(() {
      GameEngine.updateBullets(_gameState);
      final directionChanged = GameEngine.updateInvaders(_gameState);
      
      final hitCount = GameEngine.checkCollisions(_gameState);
      _gameState = _gameState.copyWith(
        score: _gameState.score + (hitCount * GameConstants.scorePerInvader),
        moveCounter: _gameState.moveCounter + 1,
        moveRight: directionChanged ? !_gameState.moveRight : _gameState.moveRight,
      );
      
      if (GameEngine.isGameOver(_gameState)) {
        _gameState = _gameState.copyWith(status: GameStatus.gameOver);
        timer.cancel();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _gameState = _gameState.copyWith(
        status: _gameState.isPaused ? GameStatus.playing : GameStatus.paused,
      );
    });
  }

  void _goToTitle() {
    _gameState.gameTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const TitleScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _restartGame() {
    _gameState.gameTimer?.cancel();
    setState(() {
      _initializeGame();
    });
  }

  void _fireBullet() {
    setState(() {
      GameEngine.fireBullet(_gameState);
    });
  }

  void _movePlayer(double delta) {
    setState(() {
      if (delta < 0) {
        _gameState.player.moveLeft();
      } else {
        _gameState.player.moveRight();
      }
    });
  }

  @override
  void dispose() {
    _gameState.gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space Invader - Score: ${_gameState.score}'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          PauseButton(
            isPaused: _gameState.isPaused,
            onPressed: _togglePause,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: GameConstants.gameWidth,
          height: GameConstants.gameHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(
            children: [
              // プレイヤーの宇宙船
              Positioned(
                left: _gameState.player.x,
                bottom: GameConstants.gameHeight - _gameState.player.y - GameConstants.playerHeight,
                child: Container(
                  width: GameConstants.playerWidth,
                  height: GameConstants.playerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              
              // 弾丸
              ..._gameState.bullets.map((bullet) => Positioned(
                left: bullet.x,
                bottom: GameConstants.gameHeight - bullet.y - GameConstants.bulletHeight,
                child: Container(
                  width: GameConstants.bulletWidth,
                  height: GameConstants.bulletHeight,
                  color: Colors.yellow,
                ),
              )),
              
              // インベーダー
              ..._gameState.invaders.map((invader) => Positioned(
                left: invader.x,
                bottom: GameConstants.gameHeight - invader.y - GameConstants.invaderHeight,
                child: Container(
                  width: GameConstants.invaderWidth,
                  height: GameConstants.invaderHeight,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )),
              
              // ゲームオーバー画面
              if (_gameState.isGameOver)
                Container(
                  width: GameConstants.gameWidth,
                  height: GameConstants.gameHeight,
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Game Clear!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Final Score: ${_gameState.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _restartGame,
                          child: const Text('Play Again'),
                        ),
                      ],
                    ),
                  ),
                ),

              // ポーズメニュー
              if (_gameState.isPaused && !_gameState.isGameOver)
                PauseMenu(
                  onResume: _togglePause,
                  onRestart: _restartGame,
                  onGoToTitle: _goToTitle,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _movePlayer(-1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.arrow_left, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: _fireBullet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.radio_button_unchecked, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () => _movePlayer(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.arrow_right, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
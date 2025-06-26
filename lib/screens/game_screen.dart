import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../models/bullet.dart';
import '../models/invader.dart';
import '../models/invader_bullet.dart';
import '../models/player.dart';
import '../services/game_engine.dart';
import '../services/high_score_service.dart';
import '../services/sound_service.dart';
import '../utils/constants.dart';
import '../widgets/pause_button.dart';
import '../widgets/pause_menu.dart';
import '../widgets/hp_bar.dart';
import 'title_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  GameState? _gameState;

  @override
  void initState() {
    super.initState();
    _initializeGameAsync();
  }
  
  void _initializeGameAsync() async {
    await _initializeGame();
  }

  Future<void> _initializeGame() async {
    final highScore = await HighScoreService.getHighScore();
    final gameState = GameState.initial(highScore: highScore);
    GameEngine.initializeInvaders(gameState);
    
    gameState.gameTimer = Timer.periodic(
      Duration(milliseconds: GameConstants.gameLoopDuration), 
      _gameLoop,
    );
    
    setState(() {
      _gameState = gameState;
    });
    
    // ゲーム開始音
    SoundService.playGameStartSound();
  }

  void _gameLoop(Timer timer) {
    try {
      if (_gameState == null || _gameState!.isPaused || _gameState!.isGameOver) return;
      
      setState(() {
        final gameState = _gameState!;
        GameEngine.updateBullets(gameState);
        GameEngine.updateInvaderBullets(gameState);
        GameEngine.generateInvaderBullet(gameState);
        
        final directionChanged = GameEngine.updateInvaders(gameState);
        final hitCount = GameEngine.checkCollisions(gameState);
        
        // インベーダー撃破時のサウンド
        if (hitCount > 0) {
          SoundService.playHitSound();
        }
        
        // プレイヤーの被弾チェック
        int newLives = gameState.lives;
        if (GameEngine.checkPlayerCollision(gameState)) {
          SoundService.playPlayerHitSound();
          newLives = gameState.lives - 1;
        }
        
        _gameState = gameState.copyWith(
          score: gameState.score + (hitCount * GameConstants.scorePerInvader),
          lives: newLives,
          moveCounter: gameState.moveCounter + 1,
          moveRight: directionChanged ? !gameState.moveRight : gameState.moveRight,
        );
        
        if (GameEngine.isGameOver(_gameState!)) {
          _gameState = _gameState!.copyWith(status: GameStatus.gameOver);
          _safelyDisposeTimer(timer);
          SoundService.playGameOverSound();
          _saveHighScoreIfNeeded();
        }
      });
    } catch (e) {
      // ゲームループでエラーが発生した場合の安全な処理
      debugPrint('Game loop error: $e');
      _gameState = _gameState?.copyWith(status: GameStatus.paused);
      _safelyDisposeTimer(timer);
    }
  }

  void _togglePause() {
    if (_gameState == null) return;
    SoundService.playButtonTapSound();
    setState(() {
      _gameState = _gameState!.copyWith(
        status: _gameState!.isPaused ? GameStatus.playing : GameStatus.paused,
      );
    });
  }

  void _goToTitle() {
    SoundService.playButtonTapSound();
    _safelyDisposeTimer(_gameState?.gameTimer);
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
    SoundService.playButtonTapSound();
    _safelyDisposeTimer(_gameState?.gameTimer);
    _initializeGameAsync();
  }

  void _fireBullet() {
    if (_gameState == null) return;
    setState(() {
      if (GameEngine.canFireBullet(_gameState!)) {
        SoundService.playShootSound();
      }
      GameEngine.fireBullet(_gameState!);
    });
  }

  void _movePlayer(double delta) {
    if (_gameState == null) return;
    setState(() {
      if (delta < 0) {
        _gameState!.player.moveLeft();
      } else {
        _gameState!.player.moveRight();
      }
    });
  }

  void _safelyDisposeTimer(Timer? timer) {
    try {
      timer?.cancel();
    } catch (e) {
      debugPrint('Timer disposal error: $e');
    }
  }

  void _saveHighScoreIfNeeded() async {
    if (_gameState == null) return;
    final isNewRecord = await HighScoreService.saveHighScore(_gameState!.score);
    if (isNewRecord) {
      SoundService.playNewHighScoreSound();
      setState(() {
        _gameState = _gameState!.copyWith(highScore: _gameState!.score);
      });
    }
  }

  @override
  void dispose() {
    _safelyDisposeTimer(_gameState?.gameTimer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = _gameState;
    if (gameState == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // スコア表示
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score: ${gameState.score}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'High: ${gameState.highScore}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // HPバー
            HPDisplay(
              currentHP: gameState.lives,
              maxHP: GameConstants.playerLives,
            ),
          ],
        ),
        actions: [
          PauseButton(
            isPaused: gameState.isPaused,
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
                left: gameState.player.x,
                bottom: GameConstants.gameHeight - gameState.player.y - GameConstants.playerHeight,
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
              
              // プレイヤーの弾丸
              ...gameState.bullets.map((bullet) => Positioned(
                left: bullet.x,
                bottom: GameConstants.gameHeight - bullet.y - GameConstants.bulletHeight,
                child: Container(
                  width: GameConstants.bulletWidth,
                  height: GameConstants.bulletHeight,
                  color: Colors.yellow,
                ),
              )),
              
              // インベーダーの弾丸
              ...gameState.invaderBullets.map((bullet) => Positioned(
                left: bullet.x,
                bottom: GameConstants.gameHeight - bullet.y - GameConstants.bulletHeight,
                child: Container(
                  width: GameConstants.bulletWidth,
                  height: GameConstants.bulletHeight,
                  color: Colors.red,
                ),
              )),
              
              // インベーダー
              ...gameState.invaders.map((invader) => Positioned(
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
              if (gameState.isGameOver)
                Container(
                  width: GameConstants.gameWidth,
                  height: GameConstants.gameHeight,
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          gameState.lives <= 0 ? 'Game Over!' : 'Game Clear!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Final Score: ${gameState.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'High Score: ${gameState.highScore}',
                          style: TextStyle(
                            color: gameState.score >= gameState.highScore ? Colors.yellow : Colors.white,
                            fontSize: 18,
                            fontWeight: gameState.score >= gameState.highScore ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (gameState.score >= gameState.highScore && gameState.score > 0)
                          const Text(
                            '🎉 NEW RECORD! 🎉',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
              if (gameState.isPaused && !gameState.isGameOver)
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
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../services/game_engine.dart';
import '../services/high_score_service.dart';
import '../services/sound_service.dart';
import '../utils/constants.dart';
import '../widgets/pause_button.dart';
import '../widgets/pause_menu.dart';
import '../widgets/hp_bar.dart';
import '../widgets/pixel_button.dart';
import '../painters/pixel_painters.dart';
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
        GameEngine.spawnRandomInvader(gameState); // ランダム出現
        
        // 自動射撃（一定間隔で発射）
        if (gameState.moveCounter % 20 == 0) { // 20フレームに1回（約0.33秒間隔）
          if (GameEngine.canFireBullet(gameState)) {
            SoundService.playShootSound();
            GameEngine.fireBullet(gameState);
          }
        }
        
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



  void _updatePlayerPosition(Offset globalPosition) {
    if (_gameState == null || _gameState!.isPaused || _gameState!.isGameOver) return;
    
    // 画面サイズを取得
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // AppBarの高さを除外
    final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight;
    
    // タッチ位置を0-1の比率に変換（画面全体を使用、端での反応を改善）
    final touchRatioX = (globalPosition.dx / screenWidth).clamp(0.0, 1.0);
    final touchRatioY = ((globalPosition.dy - appBarHeight) / availableHeight).clamp(0.0, 1.0);
    
    // 端での反応を改善するため、より敏感なマッピング
    final adjustedRatioX = touchRatioX;
    final adjustedRatioY = touchRatioY;
    
    setState(() {
      // 比率をゲーム座標に変換（調整された比率を使用）
      final gameX = adjustedRatioX * GameConstants.gameWidth;
      final gameY = adjustedRatioY * GameConstants.gameHeight;
      
      // プレイヤー位置を更新（プレイヤーの中心がタッチ位置になるように）
      final newX = gameX - GameConstants.playerWidth / 2;
      final newY = gameY - GameConstants.playerHeight / 2;
      
      // 現在の位置を取得
      final currentX = _gameState!.player.x;
      final currentY = _gameState!.player.y;
      
      // 新しい位置を計算（境界でも確実に動作するように）
      final clampedX = newX.clamp(0.0, GameConstants.gameWidth - GameConstants.playerWidth);
      final clampedY = newY.clamp(0.0, GameConstants.gameHeight - GameConstants.playerHeight);
      
      // 常に強制的に更新（境界での固着を防ぐ）
      _gameState!.player.x = clampedX;
      _gameState!.player.y = clampedY;
      
      // デバッグ用：座標を確認
      // print('Touch: (${globalPosition.dx}, ${globalPosition.dy}) -> Game: ($clampedX, $clampedY)');
    });
  }

  void _onPanStart(DragStartDetails details) {
    _updatePlayerPosition(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePlayerPosition(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    // パン終了時は何もしない（プレイヤーは最後の位置に留まる）
  }

  void _onTap(TapDownDetails details) {
    _updatePlayerPosition(details.globalPosition);
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
            // ステージ名
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'STAGE: VOID HUNTER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.red,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: Colors.red.withOpacity(0.5),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'THREAT LEVEL: EXTREME',
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.orange,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // スコア表示
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score: ${gameState.score}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'High: ${gameState.highScore}',
                    style: const TextStyle(
                      fontSize: 10,
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
            isGameOver: gameState.isGameOver,
            onPressed: _togglePause,
          ),
        ],
      ),
      body: GestureDetector(
        onTapDown: _onTap,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Column(
          children: [
            // ゲームエリア
            Expanded(
              child: Center(
                child: Container(
                  width: GameConstants.gameWidth,
                  height: GameConstants.gameHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Stack(
                    children: [
                // プレイヤーの宇宙船（SF戦闘機）
              Positioned(
                left: gameState.player.x,
                bottom: GameConstants.gameHeight - gameState.player.y - GameConstants.playerHeight,
                child: CustomPaint(
                  painter: SFFighterPainter(),
                  size: Size(GameConstants.playerWidth, GameConstants.playerHeight),
                ),
              ),
              
              // プレイヤーの弾丸（プラズマ弾）
              ...gameState.bullets.map((bullet) => Positioned(
                left: bullet.x,
                bottom: GameConstants.gameHeight - bullet.y - GameConstants.bulletHeight,
                child: CustomPaint(
                  painter: PlasmaBulletPainter(),
                  size: Size(GameConstants.bulletWidth, GameConstants.bulletHeight),
                ),
              )),
              
              // インベーダーの弾丸（エイリアン武器）
              ...gameState.invaderBullets.map((bullet) => Positioned(
                left: bullet.x,
                bottom: GameConstants.gameHeight - bullet.y - GameConstants.bulletHeight,
                child: CustomPaint(
                  painter: AlienBulletPainter(),
                  size: Size(GameConstants.bulletWidth, GameConstants.bulletHeight),
                ),
              )),
              
              // インベーダー（エイリアン侵略機）
              ...gameState.invaders.map((invader) => Positioned(
                left: invader.x,
                bottom: GameConstants.gameHeight - invader.y - GameConstants.invaderHeight,
                child: CustomPaint(
                  painter: AlienInvaderPainter(),
                  size: Size(GameConstants.invaderWidth, GameConstants.invaderHeight),
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
                        Column(
                          children: [
                            PixelButton(
                              text: 'PLAY AGAIN',
                              onPressed: _restartGame,
                              backgroundColor: Colors.blue,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              width: 200,
                              height: 50,
                            ),
                            const SizedBox(height: 15),
                            PixelButton(
                              text: 'TITLE',
                              onPressed: _goToTitle,
                              backgroundColor: Colors.green,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              width: 200,
                              height: 50,
                            ),
                          ],
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
            ),
            // フッターエリア
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.cyan, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // 戦闘機アイコン
                    CustomPaint(
                      painter: SFFighterPainter(),
                      size: const Size(40, 40),
                    ),
                    const SizedBox(width: 12),
                    // 戦闘機情報
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'NEXUS-7 FIGHTER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.cyan,
                            fontFamily: 'monospace',
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.cyan.withOpacity(0.5),
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PLASMA CANNON SYSTEM',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'monospace',
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
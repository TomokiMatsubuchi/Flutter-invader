import 'package:flutter/material.dart';
import 'dart:math';
import '../painters/pixel_painters.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_button.dart';
import 'game_screen.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _titleScaleAnimation;
  late Animation<double> _buttonPulseAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeIn,
    ));
    
    _titleScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _buttonAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _buttonPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundAnimationController);
    
    _titleAnimationController.forward();
    _buttonAnimationController.repeat(reverse: true);
    _backgroundAnimationController.repeat();
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _buttonAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  void _startGame() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const GameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            // 星空背景
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: StarFieldPainter(_backgroundAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // メインコンテンツ
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // タイトルロゴ
                  AnimatedBuilder(
                    animation: _titleAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleScaleAnimation.value,
                        child: Opacity(
                          opacity: _titleFadeAnimation.value,
                          child: Column(
                            children: [
                              // ピクセルアート風宇宙船
                              CustomPaint(
                                painter: PixelSpaceshipPainter(),
                                size: const Size(120, 80),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // ピクセルフォント風タイトル
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.green, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'SPACE INVADER',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green,
                                    letterSpacing: 3,
                                    fontFamily: 'monospace',
                                    shadows: [
                                      Shadow(
                                        color: Colors.green.shade200,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // サブタイトル
                  AnimatedBuilder(
                    animation: _titleAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _titleFadeAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.amber, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '8-BIT ARCADE CLASSIC',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // スタートボタン
                  AnimatedBuilder(
                    animation: _buttonAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonPulseAnimation.value,
                        child: PixelButton(
                          text: 'START',
                          onPressed: _startGame,
                          backgroundColor: Colors.red,
                          width: 180,
                          height: 50,
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // 遊び方の説明
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.cyan, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Text(
                            'HOW TO PLAY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 2,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(child: PixelControlInfo(symbol: '◀', label: 'LEFT')),
                            Flexible(child: PixelControlInfo(symbol: '●', label: 'FIRE')),
                            Flexible(child: PixelControlInfo(symbol: '▶', label: 'RIGHT')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // フッター
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.grey[600]!, width: 1),
                      ),
                      child: Text(
                        'MADE WITH FLUTTER',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'monospace',
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Flameを使った場合の例（参考用）
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SpaceInvaderGame extends FlameGame with HasKeyboardHandlerComponents {
  late PlayerComponent player;
  late List<InvaderComponent> invaders;
  
  @override
  Future<void> onLoad() async {
    // カメラ設定
    camera.viewfinder.visibleGameSize = Vector2(400, 600);
    
    // プレイヤー作成
    player = PlayerComponent();
    add(player);
    
    // インベーダー作成
    invaders = [];
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 8; col++) {
        final invader = InvaderComponent()
          ..position = Vector2(40.0 + col * 40.0, 50.0 + row * 40.0);
        invaders.add(invader);
        add(invader);
      }
    }
  }
}

class PlayerComponent extends SpriteComponent with HasKeyboardHandlerComponents {
  final double speed = 200.0;
  
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    size = Vector2(40, 40);
    position = Vector2(180, 520);
  }
  
  void fireBullet() {
    final bullet = BulletComponent()
      ..position = position + Vector2(20, 0);
    parent?.add(bullet);
  }
}

class InvaderComponent extends SpriteComponent {
  // インベーダーの実装
}

class BulletComponent extends SpriteComponent {
  final double speed = 300.0;
  
  @override
  void update(double dt) {
    super.update(dt);
    position.y -= speed * dt;
    
    if (position.y < 0) {
      removeFromParent();
    }
  }
}
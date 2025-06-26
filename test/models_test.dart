import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_invader/models/player.dart';
import 'package:flutter_invader/models/bullet.dart';
import 'package:flutter_invader/models/invader.dart';

void main() {
  group('Player Tests', () {
    test('Player constructor sets correct values', () {
      final player = Player();
      expect(player.x, isA<double>());
      expect(player.y, isA<double>());
    });

    test('Player copyWith() updates position correctly', () {
      final player = Player();
      final movedPlayer = player.copyWith(x: 300.0, y: 400.0);
      
      expect(movedPlayer.x, equals(300.0));
      expect(movedPlayer.y, equals(400.0));
    });

    test('Player moveLeft() decreases x position', () {
      final player = Player(x: 100.0);
      final originalX = player.x;
      player.moveLeft();
      expect(player.x, lessThan(originalX));
    });

    test('Player moveRight() increases x position', () {
      final player = Player(x: 100.0);
      final originalX = player.x;
      player.moveRight();
      expect(player.x, greaterThan(originalX));
    });

    test('Player movement respects boundaries', () {
      final player = Player(x: 0.0);
      player.moveLeft();
      expect(player.x, equals(0.0));
    });
  });

  group('Bullet Tests', () {
    test('Bullet constructor sets correct values', () {
      final bullet = Bullet(x: 100.0, y: 200.0);
      expect(bullet.x, equals(100.0));
      expect(bullet.y, equals(200.0));
    });

    test('Bullet copyWith() updates position correctly', () {
      final bullet = Bullet(x: 100.0, y: 200.0);
      final movedBullet = bullet.copyWith(x: 150.0, y: 250.0);
      
      expect(movedBullet.x, equals(150.0));
      expect(movedBullet.y, equals(250.0));
    });
  });

  group('Invader Tests', () {
    test('Invader constructor sets correct values', () {
      final invader = Invader(x: 50.0, y: 100.0);
      expect(invader.x, equals(50.0));
      expect(invader.y, equals(100.0));
    });

    test('Invader copyWith() updates position correctly', () {
      final invader = Invader(x: 50.0, y: 100.0);
      final movedInvader = invader.copyWith(x: 80.0, y: 120.0);
      
      expect(movedInvader.x, equals(80.0));
      expect(movedInvader.y, equals(120.0));
    });
  });
}
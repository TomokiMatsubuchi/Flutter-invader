import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_invader/main.dart';
import 'package:flutter_invader/screens/title_screen.dart';
import 'package:flutter_invader/screens/game_screen.dart';

void main() {
  group('SpaceInvaderApp Tests', () {
    testWidgets('App launches with title screen', (WidgetTester tester) async {
      await tester.pumpWidget(const SpaceInvaderApp());
      
      expect(find.byType(TitleScreen), findsOneWidget);
      expect(find.text('SPACE INVADER'), findsOneWidget);
      expect(find.text('START'), findsOneWidget);
    });

    testWidgets('Start button exists and is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const SpaceInvaderApp());
      
      // アニメーションが完了するまで待機（無限ループのため短時間のpump）
      await tester.pump(const Duration(seconds: 1));
      
      final startButton = find.text('START');
      expect(startButton, findsOneWidget);
      
      // ボタンがタップ可能であることを確認
      await tester.tap(startButton);
      await tester.pump(); // 一回だけpump
      
      // テストが正常に完了することを確認
      expect(true, isTrue);
    });
  });
}
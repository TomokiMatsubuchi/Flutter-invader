# 🚀 Space Invader - Flutter Edition

[![Flutter](https://img.shields.io/badge/Flutter-3.24.4-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

クラシックなスペースインベーダーゲームのFlutter実装版です。レトロな8-bit風グラフィックとモダンなFlutterアーキテクチャを融合した学習用プロジェクトです。

## 🎮 ゲーム概要

### 主な機能
- **ピクセルアート風UI**: 80年代アーケードゲーム風デザイン
- **クロスプラットフォーム対応**: Web・iOS・Android・macOS・Windows・Linuxで動作
- **ポーズ機能**: ゲーム途中でのポーズ・再開・リスタート・タイトルに戻る
- **スコアシステム**: インベーダー撃破によるスコア加算
- **アニメーション**: タイトル画面の美しいアニメーション効果

### ゲームプレイ
- **操作方法**: 左右移動ボタンで宇宙船を操作、中央ボタンで弾丸発射
- **目標**: 全てのインベーダーを撃破してゲームクリア
- **弾丸制限**: 同時に最大3発まで発射可能

## 🏗️ アーキテクチャ

このプロジェクトはFlutterのベストプラクティスに従って設計されています：

```
lib/
├── main.dart                    # アプリエントリーポイント
├── models/                      # データモデル
│   ├── bullet.dart             # 弾丸クラス
│   ├── invader.dart            # インベーダークラス  
│   ├── player.dart             # プレイヤークラス
│   └── game_state.dart         # ゲーム状態管理
├── screens/                     # 画面コンポーネント
│   ├── title_screen.dart       # タイトル画面
│   └── game_screen.dart        # ゲーム画面
├── widgets/                     # 再利用可能ウィジェット
│   ├── pixel_button.dart       # ピクセル風ボタン
│   ├── pause_menu.dart         # ポーズメニュー
│   └── pause_button.dart       # ポーズボタン
├── painters/                    # カスタムペインター
│   └── pixel_painters.dart     # ピクセルアート描画
├── services/                    # ビジネスロジック
│   └── game_engine.dart        # ゲームエンジン
└── utils/                       # 定数・ユーティリティ
    └── constants.dart           # ゲーム定数
```

### 設計原則
- **単一責任原則**: 各クラスが明確な役割を持つ
- **責任の分離**: UI・ロジック・データの分離
- **再利用性**: コンポーネント指向設計
- **保守性**: 可読性の高いコード構造

## 🛠️ 開発環境のセットアップ

### 必要な環境

1. **Flutter SDK**: 3.24.4以上
2. **Dart SDK**: 3.5以上
3. **開発環境**: VS Code、Android Studio、またはIntelliJ IDEA

### 1. Flutter SDKのインストール

#### macOS
```bash
# Homebrewを使用する場合
brew install flutter

# 手動インストールの場合
# 1. https://flutter.dev/docs/get-started/install/macos からSDKをダウンロード
# 2. zipファイルを展開
# 3. PATHを設定
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Windows
```bash
# Chocolateyを使用する場合
choco install flutter

# 手動インストールの場合
# 1. https://flutter.dev/docs/get-started/install/windows からSDKをダウンロード
# 2. zipファイルを展開
# 3. 環境変数PATHに追加
```

#### Linux
```bash
# snapを使用する場合
sudo snap install flutter --classic

# 手動インストールの場合
# 1. https://flutter.dev/docs/get-started/install/linux からSDKをダウンロード
# 2. tarファイルを展開
# 3. PATHを設定
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. 環境の確認

```bash
# Flutter環境の確認
flutter doctor

# 正常にインストールされていることを確認
flutter --version
```

### 3. エディタのセットアップ

#### VS Code
```bash
# Flutter拡張機能をインストール
# 1. VS Codeを開く
# 2. 拡張機能タブ (Ctrl+Shift+X) を開く
# 3. "Flutter" で検索してインストール
# 4. "Dart" 拡張機能も自動でインストールされます
```

#### Android Studio
```bash
# Flutter・Dartプラグインをインストール
# 1. Android Studioを開く
# 2. File > Settings > Plugins
# 3. "Flutter" で検索してインストール
# 4. IDEを再起動
```

### 4. プラットフォーム固有の設定

#### iOS開発 (macOSのみ)
```bash
# Xcodeのインストール
# App StoreからXcodeをインストール

# Xcode Command Line Toolsのインストール
sudo xcode-select --install

# CocoaPodsのインストール
sudo gem install cocoapods

# iOS Simulatorの設定
open -a Simulator
```

#### Android開発
```bash
# Android Studioをインストール
# https://developer.android.com/studio からダウンロード

# Android SDKの設定
# Android Studio > SDK Manager で必要なSDKをインストール

# Android Emulatorの作成
# Android Studio > AVD Manager で仮想デバイスを作成
```

#### Web開発
```bash
# Web開発の有効化
flutter config --enable-web

# Chrome/Edge/Firefoxがインストールされていることを確認
```

## 🚀 開発環境の立ち上げ

### 1. プロジェクトのクローンと初期設定

```bash
# リポジトリのクローン
git clone https://github.com/your-username/Flutter-invader.git
cd Flutter-invader

# 依存関係のインストール
flutter pub get

# プロジェクトの確認
flutter analyze
```

### 2. 実行環境の選択

#### Web版の起動
```bash
# Web版の実行
flutter run -d chrome

# 特定ポートでの実行
flutter run -d chrome --web-port 8080

# リリースモードでの実行
flutter run -d chrome --release
```

#### iOS版の起動 (macOSのみ)
```bash
# 利用可能なiOSデバイス/シミュレーターの確認
flutter devices

# iOS Simulatorの起動
open -a Simulator

# iOS版の実行
flutter run -d ios

# 特定のシミュレーターでの実行
flutter run -d "iPhone 16 Plus"
```

#### Android版の起動
```bash
# 利用可能なAndroidデバイス/エミュレーターの確認
flutter devices

# Android Emulatorの起動
# Android Studio > AVD Manager から起動

# Android版の実行
flutter run -d android

# 特定のエミュレーターでの実行
flutter run -d "Pixel_7_API_34"
```

#### デスクトップ版の起動
```bash
# macOS版
flutter run -d macos

# Windows版
flutter run -d windows

# Linux版
flutter run -d linux
```

### 3. 開発モードの機能

#### ホットリロード
```bash
# アプリ実行中にファイルを保存するとホットリロード
# または、ターミナルで 'r' を入力
```

#### ホットリスタート
```bash
# アプリ実行中にターミナルで 'R' を入力
# 状態をリセットしてアプリを再起動
```

#### デバッグ機能
```bash
# Flutter DevToolsの起動
flutter run --verbose
# ブラウザでデバッグツールにアクセス

# パフォーマンス分析
flutter run --profile
```

### 4. ビルドとデプロイ

#### Webアプリのビルド
```bash
# リリースビルド
flutter build web

# ビルドファイルの確認
ls build/web/

# ローカルサーバーでのテスト
cd build/web
python -m http.server 8000
```

#### モバイルアプリのビルド
```bash
# Android APKのビルド
flutter build apk --release

# iOS IPAのビルド (macOSのみ)
flutter build ios --release

# ビルドファイルの場所
# Android: build/app/outputs/flutter-apk/
# iOS: build/ios/ipa/
```

## 🧪 テストとデバッグ

### ユニットテスト
```bash
# テストの実行
flutter test

# カバレッジ付きテスト
flutter test --coverage

# 特定のテストファイルの実行
flutter test test/widget_test.dart
```

### インテグレーションテスト
```bash
# インテグレーションテストの実行
flutter drive --target=test_driver/app.dart
```

### パフォーマンス分析
```bash
# パフォーマンスプロファイル
flutter run --profile

# メモリ使用量の確認
flutter run --trace-startup
```

## 📱 対応プラットフォーム

- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **iOS** (iPhone, iPad)
- ✅ **Android** (スマートフォン, タブレット)
- ✅ **macOS** (デスクトップアプリ)
- ✅ **Windows** (デスクトップアプリ)
- ✅ **Linux** (デスクトップアプリ)

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチをプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを開く

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## 🙏 謝辞

- クラシックなスペースインベーダーゲームにインスパイアされました
- Flutterコミュニティの素晴らしいドキュメントとサンプル
- ピクセルアートアセットのインスピレーション

## 📞 サポート

- **Issues**: [GitHub Issues](https://github.com/your-username/Flutter-invader/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/Flutter-invader/discussions)
- **Documentation**: [Flutter Docs](https://flutter.dev/docs)

---

**Happy Coding! 🚀**
import '../utils/constants.dart';

class Player {
  double x;
  double y;
  
  Player({
    double? x,
    double? y,
  }) : x = x ?? (GameConstants.gameWidth / 2 - GameConstants.playerWidth / 2),
       y = y ?? GameConstants.playerY;
  
  void moveLeft() {
    x -= GameConstants.playerSpeed;
    if (x < 0) x = 0;
  }
  
  void moveRight() {
    x += GameConstants.playerSpeed;
    if (x > GameConstants.gameWidth - GameConstants.playerWidth) {
      x = GameConstants.gameWidth - GameConstants.playerWidth;
    }
  }
  
  Player copyWith({double? x, double? y}) {
    return Player(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
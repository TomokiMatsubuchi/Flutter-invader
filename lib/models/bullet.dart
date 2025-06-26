class Bullet {
  double x;
  double y;
  
  Bullet({required this.x, required this.y});
  
  Bullet copyWith({double? x, double? y}) {
    return Bullet(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
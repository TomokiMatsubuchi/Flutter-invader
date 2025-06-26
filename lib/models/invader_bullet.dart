class InvaderBullet {
  double x;
  double y;
  
  InvaderBullet({required this.x, required this.y});
  
  InvaderBullet copyWith({double? x, double? y}) {
    return InvaderBullet(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
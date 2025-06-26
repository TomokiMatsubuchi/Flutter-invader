class Invader {
  double x;
  double y;
  
  Invader({required this.x, required this.y});
  
  Invader copyWith({double? x, double? y}) {
    return Invader(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
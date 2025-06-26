import 'package:flutter/material.dart';

class HPBar extends StatefulWidget {
  final int currentHP;
  final int maxHP;
  final double width;
  final double height;

  const HPBar({
    super.key,
    required this.currentHP,
    required this.maxHP,
    this.width = 120,
    this.height = 20,
  });

  @override
  State<HPBar> createState() => _HPBarState();
}

class _HPBarState extends State<HPBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _previousHP = 0;

  @override
  void initState() {
    super.initState();
    _previousHP = widget.currentHP;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(HPBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentHP < _previousHP) {
      // HPが減った時にアニメーション
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    _previousHP = widget.currentHP;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hpPercentage = widget.currentHP / widget.maxHP;
    
    // HPの割合に応じて色を変更
    Color barColor;
    if (hpPercentage > 0.6) {
      barColor = Colors.green;
    } else if (hpPercentage > 0.3) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            // HPバー
            if (hpPercentage > 0)
              Expanded(
                flex: (hpPercentage * 100).round().clamp(1, 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: barColor,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            // 空の部分
            if (hpPercentage < 1.0)
              Expanded(
                flex: ((1 - hpPercentage) * 100).round().clamp(1, 100),
                child: Container(),
              ),
          ],
        ),
      ),
          ),
        );
      },
    );
  }
}

class HPDisplay extends StatelessWidget {
  final int currentHP;
  final int maxHP;

  const HPDisplay({
    super.key,
    required this.currentHP,
    required this.maxHP,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HPラベル
          Text(
            'HP',
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          // HPバー
          HPBar(
            currentHP: currentHP,
            maxHP: maxHP,
            width: 100,
            height: 16,
          ),
          const SizedBox(height: 4),
          // HP数値
          Text(
            '$currentHP/$maxHP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
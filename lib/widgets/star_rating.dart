// Widgets: StarRating — displays 1-3 animated stars
import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int stars; // 1, 2, or 3

  const StarRating({super.key, required this.stars});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scales = List.generate(3, (i) {
      final start = i * 0.25;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: Curves.elasticOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isEarned = i < widget.stars;
        return AnimatedBuilder(
          animation: _scales[i],
          builder: (_, __) => Transform.scale(
            scale: _scales[i].value,
            child: Icon(
              isEarned ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isEarned ? const Color(0xFFFFBE0B) : Colors.grey.shade400,
              size: 56,
            ),
          ),
        );
      }),
    );
  }
}

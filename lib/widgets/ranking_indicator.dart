import 'package:flutter/material.dart';

class RankingIndicator extends StatelessWidget {
  final String label;
  final double score;
  final Color? color;

  const RankingIndicator({
    super.key,
    required this.label,
    required this.score,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? _getDefaultColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: indicatorColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
      ],
    );
  }

  Color _getDefaultColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

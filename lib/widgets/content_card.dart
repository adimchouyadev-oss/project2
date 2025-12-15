import 'package:flutter/material.dart';
import '../models/content_model.dart';

class ContentCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onDelete;

  const ContentCard({
    super.key,
    required this.content,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and delete button
            Row(
              children: [
                Expanded(
                  child: Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Type and sentiment
            Row(
              children: [
                Icon(
                  _getTypeIcon(content.type),
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _getTypeName(content.type),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  _getSentimentIcon(content.sentiment),
                  size: 16,
                  color: _getSentimentColor(content.sentiment),
                ),
                const SizedBox(width: 4),
                Text(
                  content.sentiment.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    color: _getSentimentColor(content.sentiment),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Score indicator
            Row(
              children: [
                const Text(
                  'Overall Score:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: content.overallScore / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getScoreColor(content.overallScore),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  content.overallScore.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(content.overallScore),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Keywords chips
            if (content.keywords.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: content.keywords
                    .take(5)
                    .map((keyword) => Chip(
                          label: Text(
                            keyword,
                            style: const TextStyle(fontSize: 12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Content'),
        content: Text('Are you sure you want to delete "${content.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article;
      case ContentType.post:
        return Icons.note;
      case ContentType.product:
        return Icons.shopping_bag;
      case ContentType.social:
        return Icons.share;
      case ContentType.other:
        return Icons.description;
    }
  }

  String _getTypeName(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'Article';
      case ContentType.post:
        return 'Post';
      case ContentType.product:
        return 'Product';
      case ContentType.social:
        return 'Social Media';
      case ContentType.other:
        return 'Other';
    }
  }

  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Icons.sentiment_very_satisfied;
      case 'negative':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

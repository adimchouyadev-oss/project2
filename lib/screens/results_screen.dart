import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_model.dart';
import '../services/enrichment_service.dart';
import '../services/ranking_service.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Rankings'),
      ),
      body: Consumer2<EnrichmentService, RankingService>(
        builder: (context, enrichmentService, rankingService, child) {
          if (enrichmentService.contents.isEmpty) {
            return _buildEmptyState(context);
          }

          final rankedContents = rankingService.rankContents(enrichmentService.contents);

          return Column(
            children: [
              // Criteria selector
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rank by:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: RankingCriteria.values.map((criteria) {
                        final isSelected = rankingService.currentCriteria == criteria;
                        return ChoiceChip(
                          label: Text(rankingService.getCriteriaLabel(criteria)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              rankingService.setCriteria(criteria);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Ranked content list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rankedContents.length,
                  itemBuilder: (context, index) {
                    final content = rankedContents[index];
                    final score = _getScore(content, rankingService.currentCriteria);
                    return _buildRankedCard(context, content, index + 1, score);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No content to rank',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add and enrich content to see rankings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankedCard(BuildContext context, ContentModel content, int position, double score) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Position badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getPositionColor(position),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getTypeIcon(content.type),
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTypeName(content.type),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        _getSentimentIcon(content.sentiment),
                        size: 14,
                        color: _getSentimentColor(content.sentiment),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content.sentiment,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSentimentColor(content.sentiment),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Score bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: score / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(score),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        score.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getScore(ContentModel content, RankingCriteria criteria) {
    switch (criteria) {
      case RankingCriteria.relevance:
        return content.relevanceScore;
      case RankingCriteria.value:
        return content.valueScore;
      case RankingCriteria.impact:
        return content.impactScore;
      case RankingCriteria.seo:
        return content.seoScore;
      case RankingCriteria.overall:
        return content.overallScore;
    }
  }

  Color _getPositionColor(int position) {
    if (position == 1) return Colors.amber;
    if (position == 2) return Colors.grey[400]!;
    if (position == 3) return Colors.brown[400]!;
    return Colors.blue;
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
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
        return 'Social';
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
}

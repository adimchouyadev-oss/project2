import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_model.dart';
import '../services/enrichment_service.dart';

class EnrichmentScreen extends StatefulWidget {
  final ContentModel content;

  const EnrichmentScreen({super.key, required this.content});

  @override
  State<EnrichmentScreen> createState() => _EnrichmentScreenState();
}

class _EnrichmentScreenState extends State<EnrichmentScreen> {
  late Future<ContentModel> _enrichmentFuture;

  @override
  void initState() {
    super.initState();
    _enrichmentFuture = _enrichContent();
  }

  Future<ContentModel> _enrichContent() async {
    final service = context.read<EnrichmentService>();
    return await service.enrichContent(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Enrichment'),
      ),
      body: FutureBuilder<ContentModel>(
        future: _enrichmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildProcessingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildResultsView(snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Analyzing Content...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Extracting keywords and calculating scores',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error during analysis',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(ContentModel enrichedContent) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Title
        Text(
          enrichedContent.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),

        // Score Cards
        Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                'Overall',
                enrichedContent.overallScore,
                Icons.stars,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'SEO',
                enrichedContent.seoScore,
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                'Relevance',
                enrichedContent.relevanceScore,
                Icons.check_circle,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                'Impact',
                enrichedContent.impactScore,
                Icons.flash_on,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Sentiment
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  _getSentimentIcon(enrichedContent.sentiment),
                  color: _getSentimentColor(enrichedContent.sentiment),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sentiment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      enrichedContent.sentiment.toUpperCase(),
                      style: TextStyle(
                        color: _getSentimentColor(enrichedContent.sentiment),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Keywords
        _buildSection(
          'Keywords',
          Icons.key,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: enrichedContent.keywords
                .map((keyword) => Chip(
                      label: Text(keyword),
                      backgroundColor: Colors.blue[50],
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),

        // SEO Tags
        _buildSection(
          'SEO Tags',
          Icons.tag,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: enrichedContent.suggestedTags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.green[50],
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Improvements
        _buildSection(
          'Suggestions',
          Icons.lightbulb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: enrichedContent.improvements
                .map((improvement) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, size: 20, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(improvement)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Actions
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _saveContent(enrichedContent),
                icon: const Icon(Icons.save),
                label: const Text('Save Content'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Another'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScoreCard(String label, double score, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
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

  void _saveContent(ContentModel content) {
    final service = context.read<EnrichmentService>();
    service.addContent(content);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

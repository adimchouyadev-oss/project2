import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_model.dart';
import '../services/enrichment_service.dart';
import '../widgets/content_card.dart';
import 'content_input_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Reputation Enhancement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultsScreen(),
                ),
              );
            },
            tooltip: 'View Rankings',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'E-Reputation Enhancement',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.stars, size: 48),
                children: [
                  const Text(
                    'A Flutter application for content enrichment with semantic analysis and intelligent ranking.',
                  ),
                ],
              );
            },
            tooltip: 'About',
          ),
        ],
      ),
      body: Consumer<EnrichmentService>(
        builder: (context, service, child) {
          if (service.contents.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: service.contents.length,
            itemBuilder: (context, index) {
              final content = service.contents[index];
              return ContentCard(
                content: content,
                onDelete: () {
                  service.removeContent(content.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Content deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContentInputScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Content'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.content_paste,
              size: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'No Content Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start by adding content to analyze and enhance',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureChip(Icons.analytics, 'Smart Analysis'),
                _buildFeatureChip(Icons.trending_up, 'SEO Enhancement'),
                _buildFeatureChip(Icons.sentiment_satisfied, 'Sentiment Analysis'),
                _buildFeatureChip(Icons.grade, 'Content Ranking'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

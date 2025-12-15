import 'package:flutter/foundation.dart';
import '../models/content_model.dart';

class EnrichmentService extends ChangeNotifier {
  final List<ContentModel> _contents = [];
  
  List<ContentModel> get contents => List.unmodifiable(_contents);

  // Enrich content with simulated NLP processing
  Future<ContentModel> enrichContent(ContentModel content) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    final keywords = extractKeywords(content.originalContent);
    final sentiment = analyzeSentiment(content.originalContent);
    final seoTags = generateSEOTags(content.originalContent, content.type);
    final improvements = generateImprovements(content.originalContent, content.type);

    // Calculate scores
    final relevanceScore = _calculateRelevanceScore(keywords, content.originalContent);
    final valueScore = _calculateValueScore(content.originalContent, sentiment);
    final impactScore = _calculateImpactScore(keywords, content.type);
    final seoScore = _calculateSEOScore(content.originalContent, seoTags);
    final overallScore = (relevanceScore + valueScore + impactScore + seoScore) / 4;

    // Create enriched content with improvements applied
    final enrichedContent = _applyImprovements(content.originalContent, improvements);

    return content.copyWith(
      enrichedContent: enrichedContent,
      keywords: keywords,
      sentiment: sentiment,
      suggestedTags: seoTags,
      improvements: improvements,
      relevanceScore: relevanceScore,
      valueScore: valueScore,
      impactScore: impactScore,
      seoScore: seoScore,
      overallScore: overallScore,
    );
  }

  // Extract top keywords from text
  List<String> extractKeywords(String text) {
    // Simple keyword extraction: remove common words and get most frequent
    final words = text.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'));
    
    final commonWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'is', 'are', 'was', 'were', 'be', 'been',
      'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
      'could', 'should', 'may', 'might', 'can', 'this', 'that', 'these',
      'those', 'i', 'you', 'he', 'she', 'it', 'we', 'they', 'them', 'their'
    };

    final filtered = words.where((w) => w.length > 3 && !commonWords.contains(w)).toList();
    final frequency = <String, int>{};
    
    for (final word in filtered) {
      frequency[word] = (frequency[word] ?? 0) + 1;
    }

    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).map((e) => e.key).toList();
  }

  // Analyze sentiment: positive, negative, or neutral
  String analyzeSentiment(String text) {
    final positiveWords = [
      'good', 'great', 'excellent', 'amazing', 'wonderful', 'fantastic',
      'love', 'best', 'perfect', 'awesome', 'brilliant', 'outstanding',
      'beautiful', 'happy', 'delightful', 'success', 'successful'
    ];

    final negativeWords = [
      'bad', 'terrible', 'awful', 'horrible', 'worst', 'poor', 'hate',
      'disappointing', 'disappointed', 'problem', 'issue', 'difficult',
      'hard', 'fail', 'failed', 'failure', 'wrong', 'error'
    ];

    final lowerText = text.toLowerCase();
    int positiveCount = 0;
    int negativeCount = 0;

    for (final word in positiveWords) {
      if (lowerText.contains(word)) positiveCount++;
    }

    for (final word in negativeWords) {
      if (lowerText.contains(word)) negativeCount++;
    }

    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    return 'neutral';
  }

  // Generate SEO hashtag suggestions
  List<String> generateSEOTags(String text, ContentType type) {
    final keywords = extractKeywords(text);
    final tags = keywords.map((k) => '#${k}').toList();

    // Add type-specific tags
    switch (type) {
      case ContentType.article:
        tags.addAll(['#article', '#blog', '#content']);
        break;
      case ContentType.post:
        tags.addAll(['#post', '#socialmedia', '#content']);
        break;
      case ContentType.product:
        tags.addAll(['#product', '#review', '#quality']);
        break;
      case ContentType.social:
        tags.addAll(['#social', '#trending', '#viral']);
        break;
      case ContentType.other:
        tags.addAll(['#content', '#digital']);
        break;
    }

    return tags.take(8).toList();
  }

  // Generate content improvement suggestions
  List<String> generateImprovements(String text, ContentType type) {
    final improvements = <String>[];

    // Check length
    if (text.length < 100) {
      improvements.add('Consider expanding content to at least 100 characters for better engagement');
    }

    // Check for questions
    if (!text.contains('?')) {
      improvements.add('Add engaging questions to increase reader interaction');
    }

    // Check for calls to action
    final ctas = ['click', 'read more', 'learn more', 'subscribe', 'follow', 'share'];
    if (!ctas.any((cta) => text.toLowerCase().contains(cta))) {
      improvements.add('Include a clear call-to-action to drive user engagement');
    }

    // Type-specific improvements
    switch (type) {
      case ContentType.article:
        if (!text.contains('\n')) {
          improvements.add('Break content into paragraphs for better readability');
        }
        break;
      case ContentType.product:
        if (!text.toLowerCase().contains('benefit')) {
          improvements.add('Highlight product benefits to increase conversion');
        }
        break;
      case ContentType.social:
        if (text.length > 280) {
          improvements.add('Consider shortening for social media platforms');
        }
        if (!text.contains('#')) {
          improvements.add('Add relevant hashtags for better discoverability');
        }
        break;
      default:
        break;
    }

    if (improvements.isEmpty) {
      improvements.add('Content is well-structured and engaging');
    }

    return improvements;
  }

  double _calculateRelevanceScore(List<String> keywords, String content) {
    final score = (keywords.length * 15.0).clamp(0, 100);
    return score;
  }

  double _calculateValueScore(String content, String sentiment) {
    double score = content.length > 100 ? 60.0 : 30.0;
    if (sentiment == 'positive') score += 30;
    if (sentiment == 'neutral') score += 15;
    return score.clamp(0, 100);
  }

  double _calculateImpactScore(List<String> keywords, ContentType type) {
    double score = keywords.length * 12.0;
    if (type == ContentType.social) score += 20;
    if (type == ContentType.product) score += 15;
    return score.clamp(0, 100);
  }

  double _calculateSEOScore(String content, List<String> tags) {
    double score = tags.length * 10.0;
    if (content.contains('?')) score += 10;
    if (content.length > 150) score += 20;
    return score.clamp(0, 100);
  }

  String _applyImprovements(String original, List<String> improvements) {
    // For simulation, just return the original with a note
    return original;
  }

  // CRUD operations
  void addContent(ContentModel content) {
    _contents.add(content);
    notifyListeners();
  }

  void removeContent(String id) {
    _contents.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void updateContent(ContentModel content) {
    final index = _contents.indexWhere((c) => c.id == content.id);
    if (index != -1) {
      _contents[index] = content;
      notifyListeners();
    }
  }

  ContentModel? getContent(String id) {
    try {
      return _contents.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}

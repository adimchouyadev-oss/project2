import 'package:flutter/foundation.dart';
import '../models/content_model.dart';

enum RankingCriteria {
  relevance,
  value,
  impact,
  seo,
  overall,
}

class RankingService extends ChangeNotifier {
  RankingCriteria _currentCriteria = RankingCriteria.overall;

  RankingCriteria get currentCriteria => _currentCriteria;

  void setCriteria(RankingCriteria criteria) {
    _currentCriteria = criteria;
    notifyListeners();
  }

  // Rank contents by selected criteria
  List<ContentModel> rankContents(List<ContentModel> contents) {
    final sorted = List<ContentModel>.from(contents);

    sorted.sort((a, b) {
      final scoreA = _getScore(a, _currentCriteria);
      final scoreB = _getScore(b, _currentCriteria);
      return scoreB.compareTo(scoreA); // Descending order
    });

    return sorted;
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

  String getCriteriaLabel(RankingCriteria criteria) {
    switch (criteria) {
      case RankingCriteria.relevance:
        return 'Relevance';
      case RankingCriteria.value:
        return 'Value';
      case RankingCriteria.impact:
        return 'Impact';
      case RankingCriteria.seo:
        return 'SEO';
      case RankingCriteria.overall:
        return 'Overall';
    }
  }
}

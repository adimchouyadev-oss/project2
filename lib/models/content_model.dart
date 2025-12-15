enum ContentType {
  article,
  post,
  product,
  social,
  other,
}

class ContentModel {
  final String id;
  final String title;
  final String originalContent;
  final String? enrichedContent;
  final ContentType type;
  
  // Score fields
  final double relevanceScore;
  final double valueScore;
  final double impactScore;
  final double seoScore;
  final double overallScore;
  
  // Analysis fields
  final List<String> keywords;
  final List<String> suggestedTags;
  final String sentiment;
  final List<String> improvements;

  const ContentModel({
    required this.id,
    required this.title,
    required this.originalContent,
    this.enrichedContent,
    required this.type,
    this.relevanceScore = 0.0,
    this.valueScore = 0.0,
    this.impactScore = 0.0,
    this.seoScore = 0.0,
    this.overallScore = 0.0,
    this.keywords = const [],
    this.suggestedTags = const [],
    this.sentiment = 'neutral',
    this.improvements = const [],
  });

  ContentModel copyWith({
    String? id,
    String? title,
    String? originalContent,
    String? enrichedContent,
    ContentType? type,
    double? relevanceScore,
    double? valueScore,
    double? impactScore,
    double? seoScore,
    double? overallScore,
    List<String>? keywords,
    List<String>? suggestedTags,
    String? sentiment,
    List<String>? improvements,
  }) {
    return ContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      originalContent: originalContent ?? this.originalContent,
      enrichedContent: enrichedContent ?? this.enrichedContent,
      type: type ?? this.type,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      valueScore: valueScore ?? this.valueScore,
      impactScore: impactScore ?? this.impactScore,
      seoScore: seoScore ?? this.seoScore,
      overallScore: overallScore ?? this.overallScore,
      keywords: keywords ?? this.keywords,
      suggestedTags: suggestedTags ?? this.suggestedTags,
      sentiment: sentiment ?? this.sentiment,
      improvements: improvements ?? this.improvements,
    );
  }
}

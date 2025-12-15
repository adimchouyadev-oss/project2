# E-Reputation Enhancement Flutter App

A complete Flutter application for content enrichment with semantic analysis and intelligent ranking.

## Features

- **Content Management**: Add, view, and delete content items
- **Semantic Enrichment**: Automatic keyword extraction and content analysis
- **Sentiment Analysis**: Detect positive, negative, or neutral sentiment
- **SEO Enhancement**: Generate hashtag suggestions and SEO scores
- **Intelligent Ranking**: Rank content by multiple criteria (relevance, value, impact, SEO, overall)
- **Content Improvements**: Get AI-powered suggestions to enhance content

## Project Structure

```
lib/
├── main.dart                          # App entry point with provider setup
├── models/
│   └── content_model.dart            # ContentModel with enum and copyWith
├── services/
│   ├── enrichment_service.dart       # NLP processing and content management
│   └── ranking_service.dart          # Content ranking logic
├── screens/
│   ├── home_screen.dart              # Main screen with content list
│   ├── content_input_screen.dart     # Form to add new content
│   ├── enrichment_screen.dart        # Processing and results display
│   └── results_screen.dart           # Ranked content view
└── widgets/
    ├── content_card.dart             # Content display card
    └── ranking_indicator.dart        # Score visualization widget
```

## Dependencies

- `flutter`: Flutter SDK
- `provider: ^6.1.1`: State management
- `cupertino_icons: ^1.0.6`: iOS-style icons

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Running Tests

```bash
flutter test
```

## Usage

1. **Add Content**: Tap the "Add Content" button to create new content
2. **Fill Form**: Enter title, select content type, and add content (min 50 characters)
3. **Analyze**: Submit the form to process and enrich the content
4. **View Results**: See scores, keywords, sentiment, and improvement suggestions
5. **Save**: Save enriched content to your collection
6. **View Rankings**: Access the rankings screen to compare content by different criteria

## Features Details

### Content Types
- Article
- Post
- Product
- Social Media
- Other

### Scoring System
- **Relevance Score**: Based on keyword density and content structure
- **Value Score**: Content length and sentiment analysis
- **Impact Score**: Keyword relevance and content type
- **SEO Score**: Hashtags, questions, and content optimization
- **Overall Score**: Average of all scores

### Sentiment Analysis
Automatically detects:
- Positive sentiment
- Negative sentiment
- Neutral sentiment

### Content Improvements
AI-powered suggestions for:
- Content length optimization
- Adding engaging questions
- Call-to-action recommendations
- Type-specific improvements
- Hashtag suggestions

## UI/UX

- Material 3 design system
- Color scheme with blue seed color
- Responsive layouts
- Smooth animations and transitions
- Empty states with feature highlights
- Progress indicators during processing
- Color-coded scores and rankings

## Testing

Comprehensive widget tests covering:
- App launch and home screen display
- Navigation between screens
- Form validation
- Content enrichment flow
- Rankings display
- About dialog

## License

This project is part of a coding assessment.
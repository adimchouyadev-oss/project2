import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project2/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title appears in the AppBar
    expect(find.text('E-Reputation Enhancement'), findsOneWidget);

    // Verify empty state is shown
    expect(find.text('No Content Yet'), findsOneWidget);
    expect(find.text('Start by adding content to analyze and enhance'), findsOneWidget);

    // Verify feature chips are present
    expect(find.text('Smart Analysis'), findsOneWidget);
    expect(find.text('SEO Enhancement'), findsOneWidget);
    expect(find.text('Sentiment Analysis'), findsOneWidget);
    expect(find.text('Content Ranking'), findsOneWidget);

    // Verify add content button is present
    expect(find.text('Add Content'), findsOneWidget);
  });

  testWidgets('Navigation to content input screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap the add content button
    await tester.tap(find.text('Add Content'));
    await tester.pumpAndSettle();

    // Verify we're on the content input screen
    expect(find.text('Add Content'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content Type'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('Form validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to content input screen
    await tester.tap(find.text('Add Content'));
    await tester.pumpAndSettle();

    // Try to submit without filling the form
    await tester.tap(find.text('Analyze & Enrich'));
    await tester.pumpAndSettle();

    // Verify validation messages appear
    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Content is required'), findsOneWidget);
  });

  testWidgets('Form with valid data navigates to enrichment', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to content input screen
    await tester.tap(find.text('Add Content'));
    await tester.pumpAndSettle();

    // Fill in the form with valid data
    await tester.enterText(find.byType(TextFormField).first, 'Test Article Title');
    await tester.enterText(
      find.byType(TextFormField).last,
      'This is a test article content with more than fifty characters to pass validation.',
    );

    // Submit the form
    await tester.tap(find.text('Analyze & Enrich'));
    await tester.pumpAndSettle();

    // Verify we're on the enrichment screen
    expect(find.text('Content Enrichment'), findsOneWidget);
    expect(find.text('Analyzing Content...'), findsOneWidget);
  });

  testWidgets('Rankings button navigates to results screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap the rankings button in app bar
    await tester.tap(find.byIcon(Icons.analytics));
    await tester.pumpAndSettle();

    // Verify we're on the results screen
    expect(find.text('Content Rankings'), findsOneWidget);
    expect(find.text('No content to rank'), findsOneWidget);
  });

  testWidgets('About dialog can be opened', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap the about button
    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    // Verify about dialog appears
    expect(find.text('E-Reputation Enhancement'), findsWidgets);
    expect(find.text('1.0.0'), findsOneWidget);
  });
}

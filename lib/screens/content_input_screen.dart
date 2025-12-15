import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'enrichment_screen.dart';

class ContentInputScreen extends StatefulWidget {
  const ContentInputScreen({super.key});

  @override
  State<ContentInputScreen> createState() => _ContentInputScreenState();
}

class _ContentInputScreenState extends State<ContentInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  ContentType _selectedType = ContentType.article;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Content'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter content title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ContentType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Content Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: ContentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter your content here (minimum 50 characters)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Content is required';
                }
                if (value.length < 50) {
                  return 'Content must be at least 50 characters (current: ${value.length})';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analyze & Enrich'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final content = ContentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        originalContent: _contentController.text,
        type: _selectedType,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EnrichmentScreen(content: content),
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learning/http_crud_new/article.dart';
import 'package:stacked/stacked.dart';

class MyDataTableVM extends BaseViewModel {
  List<Article> articles = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String? publishedValue;
  String _searchQuery = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> get columns => [
    'ID',
    'Title',
    'Description',
    'Body',
    'Published',
  ];

  List<Article> get filteredArticles => _searchQuery.isEmpty
      ? articles
      : articles
          .where(
            (a) =>
                a.title.toLowerCase().contains(_searchQuery) ||
                a.description.toLowerCase().contains(_searchQuery),
          )
          .toList();

  List<List<String>> get rows => filteredArticles
      .map(
        (a) => [
          a.id.toString(),
          a.title,
          a.description,
          a.body,
          a.published ? 'Yes' : 'No',
        ],
      )
      .toList();

  void onSearchChanged(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<void> getArticles() async {
    setBusy(true);
    final url = Uri.parse('http://localhost:4000/article/drafts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List) {
          articles = data
              .whereType<Map<String, dynamic>>()
              .map(Article.fromJson)
              .toList();
        } else if (data is Map<String, dynamic>) {
          articles = [Article.fromJson(data)];
        } else {
          debugPrint('Unexpected JSON format: ${data.runtimeType}');
        }
        notifyListeners();
      } else {
        debugPrint('Error status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> postArticle(Article article) async {
    final url = Uri.parse('http://localhost:4000/article');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': article.title,
          'description': article.description,
          'body': article.body,
          'published': article.published,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        debugPrint('Post error: ${response.statusCode} — ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<bool> updateArticle(Article article) async {
    final url = Uri.parse('http://localhost:4000/article/${article.id}');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': article.title,
          'description': article.description,
          'body': article.body,
          'published': article.published,
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('Error updating: $e');
      return false;
    }
  }

  Future<bool> deleteArticle(Article article) async {
    final url = Uri.parse('http://localhost:4000/article/${article.id}');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        articles.removeWhere((a) => a.id == article.id);
        notifyListeners();
        return true;
      }
      debugPrint('Delete error: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('Error deleting: $e');
      return false;
    }
  }

  Future<void> _addArticle(BuildContext ctx) async {

    if (!formKey.currentState!.validate()) return;
    final nextId = articles.isEmpty
        ? 1
        : articles.map((a) => a.id).reduce(max) + 1;
    final article = Article(
      id: nextId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      body: bodyController.text.trim(),
      published: publishedValue == 'yes',
    );

    final success = await postArticle(article);
    if (!success) return;
    articles.add(article);
    notifyListeners();
    _clearControllers();
    if (ctx.mounted) Navigator.of(ctx).pop(true);
  }

  Future<void> _editArticle(BuildContext ctx, Article original) async {
    if (!formKey.currentState!.validate()) return;
    final updated = Article(
      id: original.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      body: bodyController.text.trim(),
      published: publishedValue == 'yes',
    );
    final success = await updateArticle(updated);
    if (!success) return;
    final index = articles.indexWhere((a) => a.id == original.id);
    if (index != -1) {
      articles[index] = updated;
      notifyListeners();
    }
    _clearControllers();
    if (ctx.mounted) Navigator.of(ctx).pop(true);
  }

  Future<bool?> openDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: _dialogInsetPadding(context),
        title: const Text('Add New Article'),
        content: _buildFormContent(),
        actions: [
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.of(ctx).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => _addArticle(ctx),
            icon: const Icon(Icons.add),
            label: const Text('Add Article'),
          ),
        ],
      ),
    );
  }

  Future<bool?> openEditDialog(BuildContext context, Article article) {
    titleController.text = article.title;
    descriptionController.text = article.description;
    bodyController.text = article.body;
    publishedValue = article.published ? 'yes' : 'no';
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: _dialogInsetPadding(context),
        title: Text('Edit Article #${article.id}'),
        content: _buildFormContent(),
        actions: [
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.of(ctx).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => _editArticle(ctx, article),
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  EdgeInsets _dialogInsetPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = max(16.0, (w - 520) / 2);
    return EdgeInsets.symmetric(horizontal: h, vertical: 24);
  }

  Widget _buildFormContent() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            TextFormField(
              controller: titleController,
              decoration: _fieldDecoration('Title', Icons.person),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController,
              decoration: _fieldDecoration('Description', Icons.person_outline),
              keyboardType: TextInputType.multiline,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: bodyController,
              decoration: _fieldDecoration('Body', Icons.email_outlined),
              keyboardType: TextInputType.multiline,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: publishedValue,
              decoration: _fieldDecoration('Published', Icons.badge_outlined),
              items: const [
                DropdownMenuItem(value: 'yes', child: Text('Yes')),
                DropdownMenuItem(value: 'no', child: Text('No')),
              ],
              onChanged: (value) {
                publishedValue = value;
              },
              validator: (value) => value == null ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      );

  void _clearControllers() {
    titleController.clear();
    descriptionController.clear();
    bodyController.clear();
    publishedValue = null;
  }
}

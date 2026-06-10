import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:learning/http_crud_new/article.dart';
import 'package:stacked/stacked.dart';

class HttpCrudVM extends BaseViewModel {
  bool isLoading = false;
  bool isListEmpty = true;
  String errorMessage = '';
  List<Article> articles = [];

  Future<void> getData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // String baseURL = 'https://api.sampleapis.com/coffee/hot';
    String baseURL =
        'https://f3bb-2407-d000-1a-2892-6c69-400f-d9ac-ea80.ngrok-free.app/articles';

    final url = Uri.parse(baseURL);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is List) {
          articles = data
              .map((item) => Article.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          articles = [Article.fromJson(data)];
        } else {
          articles = [];
        }

        isListEmpty = articles.isEmpty;
        isLoading = false;
        notifyListeners();
      } else {
        errorMessage = 'Request failed with error code ${response.statusCode}';
        isListEmpty = true;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Error occured $e';
      isListEmpty = true;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteData(Article article) async {
    errorMessage = '';

    final articleId = article.id;
    if (articleId <= 0) {
      errorMessage = 'No articleId given';
      return;
    }

    final url = Uri.parse(
      'https://f3bb-2407-d000-1a-2892-6c69-400f-d9ac-ea80.ngrok-free.app/articles/$articleId',
    );

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        articles.remove(article);
        isListEmpty = articles.isEmpty;
      } else {
        errorMessage = 'Delete failed with error code ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error occured $e';
    }

    notifyListeners();
  }

  Future<void> patchData(
    Article oldArticle,
    String title,
    String body,
    String description,
    bool published,
  ) async {
    errorMessage = '';
    Map<String, dynamic> updates = {};

    String newTitle = title.trim();
    String newBody = body.trim();

    if (newTitle != oldArticle.title) {
      updates['title'] = newTitle;
    }
    if (newBody != oldArticle.body) {
      updates['body'] = newBody;
    }
    if (updates.isEmpty) {
      errorMessage = 'No changes have been made to data';
      return;
    }

    updates['updatedAt'] = DateTime.now().toIso8601String();

    int articleId = oldArticle.id;

    final url = Uri.parse(
      'https://f3bb-2407-d000-1a-2892-6c69-400f-d9ac-ea80.ngrok-free.app/articles/$articleId',
    );

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        int index = articles.indexOf(oldArticle);

        if (index != -1) {
          articles[index] = Article(
            id: articleId,
            title: title,
            body: body,
            description: description,
            published: published,
          );
        }
      } else {
        errorMessage = 'Request failed with code ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error occured: $e';
    }

    notifyListeners();
  }

  // Future<void> postData(){

  // }

  String? validateArticleTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title cannot be empty.';
    }

    return null;
  }

  String? validateArticleBody(String? body) {
    if (body == null) {
      return 'Body must not be null';
    }

    return null;
  }
}

import 'package:learning/data_table/api_client.dart';
import 'package:learning/http_crud_new/article.dart';

class ArticleApiService {
  static ApiClient get _client => ApiClient.instance;

  static Future<Article> getArticle(int id) {
    return _client.get<Article>(
      endpoint: '/article',
      fromJson: (json) => Article.fromJson(json),
    );
  }

  static Future<List<Article>> getArticles({required int page, required int pageSize}) {
    return _client.get<List<Article>>(
      endpoint: '/article',
      queryParams: {'page' : page.toString(), 'pageSize': pageSize.toString()},
      fromJson: (json) =>
          (json as List).map((e) => Article.fromJson(e)).toList(),
    );
  }

  static Future<Article> createArticle(Article article) {
    return _client.post(
      endpoint: '/article',
      body: article.toJson(),
      fromJson: Article.fromJson,
    );
  }

  static Future<Article> patchArticle(int id, Map<String, dynamic> changes) {
    return _client.patch(
      endpoint: '/article',
      id: id,
      changes: changes,
      fromJson: Article.fromJson,
    );
  }

  static Future<bool> deleteArticle(int id) {
    return _client.delete(endpoint: '/article', id: id);
  }
}

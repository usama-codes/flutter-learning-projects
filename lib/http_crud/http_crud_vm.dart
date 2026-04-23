import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

class HttpCrudVM extends BaseViewModel {
  final baseURL = "https://jsonplaceholder.typicode.com/posts";
  List<dynamic> data = [];
  bool showBlog = false;
  int? blogIndex;
  bool isError = false;
  String errorMessage = "";

  Future fetchData() async {
    setBusy(true);
    isError = false;
    errorMessage = "";

    try {
      final response = await http
          .get(
            Uri.parse(baseURL),
            headers: {
              "Accept": "application/json",
              "User-Agent": "stacked-counter",
            },
          )
          .timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        showBlog = false;
        blogIndex = null;
      } else {
        isError = true;
        errorMessage =
            "HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Request failed'}";
        debugPrint("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
      debugPrint("fetchData failed: $e");
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void openBlog(int index) {
    blogIndex = index;
    showBlog = true;
    notifyListeners();
  }

  void backToList() {
    showBlog = false;
    blogIndex = null;
    notifyListeners();
  }
}

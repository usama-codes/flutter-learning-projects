import 'package:flutter/material.dart';
import 'package:learning/http_crud_new/article.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.58, 1.0],
              colors: [
                Color.fromARGB(255, 216, 243, 255),
                Color(0xFFE9F7FF),
                Color(0xFFFDFEFF),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                          Text(
                            article.body,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Wrap(spacing: 8, runSpacing: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

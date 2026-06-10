import 'package:flutter/material.dart';
import 'package:learning/data_table/extensions.dart';
import 'package:learning/http_crud_new/article.dart';

class ArticleDetailVU extends StatelessWidget {
  const ArticleDetailVU({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderBackground(article: article),
                  24.height,
                  Card(
                    child: Column(
                      children: [
                        _DetailTile(
                          icon: Icons.tag_rounded,
                          label: 'ID',
                          value: '${article.id}',
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.title_rounded,
                          label: 'Title',
                          value: article.title,
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.description_outlined,
                          label: 'Description',
                          value: article.description,
                        ),
                        const Divider(height: 1, indent: 56),
                        _DetailTile(
                          icon: Icons.article_outlined,
                          label: 'Body',
                          value: article.body,
                        ),
                        const Divider(height: 1, indent: 56),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.public_rounded,
                                size: 22,
                                color: const Color(0xFF4F6AF5),
                              ),
                              18.width,
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Published',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              _StatusChip(published: article.published),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F6AF5), Color(0xFF7966D5)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 46,
          backgroundColor: Colors.white.withAlpha(45),
          foregroundColor: Colors.white,
          child: Text(
            article.title.isNotEmpty ? article.title[0].toUpperCase() : 'A',
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF4F6AF5)),
          18.width,
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(color: const Color(0xFF44464F)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.published});

  final bool published;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: published
            ? Colors.green.withAlpha(30)
            : Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: published ? Colors.green.shade600 : Colors.grey.shade400,
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            published ? Icons.check_circle_outline : Icons.unpublished_outlined,
            size: 14,
            color: published ? Colors.green.shade700 : Colors.grey.shade600,
          ),
          5.width,
          Text(
            published ? 'Published' : 'Draft',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: published ? Colors.green.shade700 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

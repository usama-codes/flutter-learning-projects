import 'package:flutter/material.dart';
import 'package:learning/data_table_scratch/data_table_vm.dart';
import 'package:learning/http_crud_new/article.dart';
import 'package:learning/http_crud_new/article_detail_page.dart';
import 'package:stacked/stacked.dart';

class MyDataTableVU extends StackedView<MyDataTableVM> {
  const MyDataTableVU({super.key});

  @override
  Widget builder(BuildContext context, MyDataTableVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Table'),
        actions: [
          IconButton(
            onPressed: () => viewModel.openDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: viewModel.searchController,
                    onChanged: viewModel.onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search by title or description...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 700) {
                        return _buildTable(context, viewModel);
                      }
                      return _buildCardList(context, viewModel);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTable(BuildContext context, MyDataTableVM viewModel) {
    final articles = viewModel.filteredArticles;
    final rows = viewModel.rows;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(color: Colors.black26),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.black12),
              children: [
                ...viewModel.columns.map(
                  (col) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      col,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            ...articles.asMap().entries.map((entry) {
              final i = entry.key;
              final article = entry.value;
              return TableRow(
                children: [
                  ...rows[i].map(
                    (cell) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(cell),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () =>
                              viewModel.openEditDialog(context, article),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () => viewModel.deleteArticle(article),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCardList(BuildContext context, MyDataTableVM viewModel) {
    final articles = viewModel.filteredArticles;

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: articles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _ArticleCard(
          article: article,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleDetailPage(article: article),
            ),
          ),
          onEdit: () => viewModel.openEditDialog(context, article),
          onDelete: () => viewModel.deleteArticle(article),
        );
      },
    );
  }

  @override
  MyDataTableVM viewModelBuilder(BuildContext context) => MyDataTableVM();

  @override
  void onViewModelReady(MyDataTableVM viewModel) => viewModel.getArticles();
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.article,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Article article;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          article.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${article.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: article.published
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    article.published ? 'Published' : 'Draft',
                    style: TextStyle(
                      fontSize: 11,
                      color: article.published
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              article.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}

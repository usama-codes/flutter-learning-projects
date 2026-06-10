import 'package:flutter/material.dart';
import 'package:learning/http_crud_new/article.dart';
import 'package:learning/http_crud_new/article_detail_page.dart';
import 'package:learning/http_crud_new/http_crud_vm.dart';
import 'package:stacked/stacked.dart';

class HttpCrudVU extends StackedView<HttpCrudVM> {
  const HttpCrudVU({super.key});

  @override
  Widget builder(BuildContext context, HttpCrudVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HTTP Crud App"),
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 215, 243, 254), Colors.white],
          ),
        ),
        child: SafeArea(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        Text(
                          viewModel.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: viewModel.getData,
                          label: const Text("Try again"),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                )
              : viewModel.isListEmpty
              ? Center(
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 36,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            "No articles found",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: viewModel.getData,
                            label: const Text("Reload articles"),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: viewModel.getData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: viewModel.articles.length,
                    itemBuilder: (context, index) {
                      final article = viewModel.articles[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: _ArticleCard(
                          article: article,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArticleDetailPage(article: article),
                              ),
                            );
                          },
                          onEdit: () =>
                              _showEditDialog(context, viewModel, article),
                          onDelete: () =>
                              _showDeleteDialog(context, viewModel, article),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  @override
  HttpCrudVM viewModelBuilder(BuildContext context) {
    final viewModel = HttpCrudVM();
    Future.microtask(viewModel.getData);
    return viewModel;
  }

  void _showDeleteDialog(
    BuildContext context,
    HttpCrudVM viewModel,
    Article article,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete article?'),
          content: Text('Delete "${article.title}" from the list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await viewModel.deleteData(article);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    HttpCrudVM viewModel,
    Article article,
  ) {
    final titleController = TextEditingController(text: article.title);
    final bodyController = TextEditingController(text: article.body);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          title: const Text('Edit article'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 14,
              children: [
                TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  validator: viewModel.validateArticleTitle,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: 7,
                  validator: viewModel.validateArticleBody,
                  decoration: const InputDecoration(labelText: 'Body'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final isValid = formKey.currentState?.validate() ?? false;

                if (!isValid) {
                  return;
                }

                viewModel.patchData(
                  article,
                  titleController.text,
                  bodyController.text,
                  article.description,
                  article.published,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save changes'),
            ),
          ],
        );
      },
    );
  }
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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 48,
          height: 48,
          child: const Icon(Icons.article_outlined, color: Colors.blueGrey),
        ),
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          article.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, height: 1.2),
        ),
        trailing: Wrap(
          spacing: -5,
          children: [
            IconButton(
              tooltip: 'Edit article',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete article',
              onPressed: onDelete,
              color: Colors.red,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

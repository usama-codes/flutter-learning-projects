import 'package:flutter/material.dart';
import 'package:learning/http_crud/http_crud_vm.dart';
import 'package:stacked/stacked.dart';

class HttpCrudVU extends StackedView<HttpCrudVM> {
  const HttpCrudVU({super.key});

  @override
  Future<void> onViewModelReady(HttpCrudVM viewModel) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchData();
    });
  }

  @override
  Widget builder(BuildContext context, HttpCrudVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_rounded, color: Color(0xFF2C95CA)),
            SizedBox(width: 12),
            Text(
              'Users',
              style: TextStyle(
                color: Color(0xFF2C95CA),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: viewModel.fetchData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.showCreateDialog(context),
        backgroundColor: const Color(0xFF2C95CA),
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add_rounded),
      ),
      body: viewModel.isBusy && viewModel.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : viewModel.isError && viewModel.users.isEmpty
          ? _ErrorState(
              message: viewModel.errorMessage.isEmpty
                  ? 'Something went wrong while loading users.'
                  : viewModel.errorMessage,
              onRetry: viewModel.fetchData,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: _EndpointCard(endpoint: HttpCrudVM.apiEndpoint),
                ),
                if (viewModel.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: _InlineErrorBanner(
                      message: viewModel.errorMessage,
                      onRetry: viewModel.fetchData,
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.fetchData,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10,
                      ),
                      itemCount: viewModel.users.length,
                      itemBuilder: (context, index) {
                        final user = viewModel.users[index];
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => viewModel.showPost(context, index),
                            leading: _Avatar(url: user.avatar),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            subtitle: Text(user.email),
                            trailing: Wrap(
                              spacing: -5,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      viewModel.showEditDialog(context, index),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFF5A83AD),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => viewModel.delete(user.id),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  HttpCrudVM viewModelBuilder(BuildContext context) => HttpCrudVM();
}

class _Avatar extends StatelessWidget {
  final String url;
  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Color(0xFF2C95CA),
        child: Icon(Icons.person, color: Colors.white),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      backgroundColor: const Color(0xFFE0E0E0),
    );
  }
}

class _EndpointCard extends StatelessWidget {
  final String endpoint;

  const _EndpointCard({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public CRUD endpoint',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(endpoint, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Read-only summary. Use the buttons below to create, update, or delete users.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MethodChip(label: 'GET /users'),
                _MethodChip(label: 'POST /users/add'),
                _MethodChip(label: 'PUT /users/{id}'),
                _MethodChip(label: 'PATCH /users/{id}'),
                _MethodChip(label: 'DELETE /users/{id}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final String label;

  const _MethodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C95CA),
      ),
      backgroundColor: const Color(0xFFEAF6FB),
      side: BorderSide.none,
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _InlineErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF2F2),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest refresh failed',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () async => onRetry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Color(0xFF2C95CA),
            ),
            const SizedBox(height: 16),
            const Text(
              'Could not load users',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

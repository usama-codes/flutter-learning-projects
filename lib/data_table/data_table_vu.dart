import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learning/data_table/data_table_vm.dart';
import 'package:learning/data_table/article_detail.dart';
import 'package:learning/data_table/extensions.dart';
import 'package:learning/data_table/generic_data_screen.dart';
import 'package:learning/data_table/person.dart';
import 'package:learning/data_table/person_detail.dart';
import 'package:learning/http_crud_new/article.dart';
import 'package:stacked/stacked.dart';

class GenericDataTableVU<T> extends StackedView<GenericDataVM<T>> {
  const GenericDataTableVU({
    super.key,
    required this.endpoint,
    required this.fromJson,
    required this.toJson,
    required this.getId,
    required this.getDisplayName,
    required this.columns,
    required this.matchesSearch,
    required this.matchesColumn,
    required this.sortValue,
    required this.buildCells,
    required this.buildFormDialog,
    required this.title,
    required this.entityLabel,
    required this.cardBuilder,
    this.onRowTap,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyMessage = 'No items found',
    this.extraActionsBuilder,
  });

  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final int Function(T) getId;
  final String Function(T) getDisplayName;
  final List<String> columns;
  final bool Function(T, String) matchesSearch;
  final bool Function(T, String, String) matchesColumn;
  final Comparable Function(T, int) sortValue;
  final List<DataCell> Function(T) buildCells;
  final Widget Function(BuildContext, T?, int, Future<void> Function(T))
  buildFormDialog;
  final String title;
  final String entityLabel;
  final CardBuilder<T> cardBuilder;
  final void Function(BuildContext, T)? onRowTap;
  final IconData emptyIcon;
  final String emptyMessage;
  final List<Widget> Function(BuildContext)? extraActionsBuilder;

  @override
  GenericDataVM<T> viewModelBuilder(BuildContext context) => GenericDataVM<T>(
    endpoint: endpoint,
    fromJson: fromJson,
    toJson: toJson,
    getId: getId,
    getDisplayName: getDisplayName,
    columns: columns,
    matchesSearch: matchesSearch,
    matchesColumn: matchesColumn,
    sortValue: sortValue,
    buildCells: buildCells,
    buildFormDialog: buildFormDialog,
  );

  @override
  Widget builder(
    BuildContext context,
    GenericDataVM<T> viewModel,
    Widget? child,
  ) {
    final selectedCount = viewModel.selectedIds.length;
    T? singleSelected;
    if (selectedCount == 1) {
      final id = viewModel.selectedIds.first;
      try {
        singleSelected = viewModel.items.firstWhere((i) => getId(i) == id);
      } catch (_) {}
    }
    final resolvedSelected = singleSelected;
    final canEditSelection = selectedCount == 1 && resolvedSelected != null;
    final canDeleteSelection = selectedCount > 0;

    return GenericDataScreen<T>(
      title: title,
      entityLabel: entityLabel,
      filteredItems: viewModel.filteredItems,
      isBusy: viewModel.isBusy,
      scrollController: viewModel.scrollController,
      searchQuery: viewModel.searchQuery,
      onSearch: viewModel.updateSearch,
      onRefresh: viewModel.refresh,
      onClearFilters: viewModel.hasActiveFilters
          ? viewModel.clearAllFilters
          : null,
      cardBuilder: cardBuilder,
      onEditItem: (item) => viewModel.openEditDialog(context, item),
      onDeleteItem: (item) => viewModel.confirmDelete(context, item),
      columns: viewModel.getColumns(context),
      rowsBuilder: (items) => viewModel.getRows(
        items,
        onRowTap: onRowTap != null
            ? (item) => onRowTap!(context, item)
            : null,
      ),
      sortColumnIndex: viewModel.selectedColumnIndex,
      sortAscending: viewModel.isAscending,
      page: viewModel.page,
      hasNextPage: viewModel.hasNextPage,
      pageRangeLabel: viewModel.pageRangeLabel,
      onNextPage: viewModel.loadNextPage,
      onPrevPage: viewModel.loadPrevPage,
      onAdd: () => viewModel.openDialog(context),
      selectedCount: selectedCount,
      canEdit: canEditSelection,
      onEditSelected: resolvedSelected != null
          ? () => viewModel.openEditDialog(context, resolvedSelected)
          : null,
      canDelete: canDeleteSelection,
      onDeleteSelected: canDeleteSelection
          ? () {
              if (resolvedSelected != null) {
                viewModel.confirmDelete(context, resolvedSelected);
              } else {
                viewModel.confirmDeleteSelected(context);
              }
            }
          : null,
      deleteLabel: selectedCount > 1
          ? 'Delete $selectedCount selected'
          : 'Delete selected',
      emptyIcon: emptyIcon,
      emptyMessage: emptyMessage,
      extraActions: extraActionsBuilder?.call(context) ?? const [],
    );
  }
}

Widget buildArticlesScreen({
  List<Widget> Function(BuildContext)? extraActionsBuilder,
}) {
  return GenericDataTableVU<Article>(
    endpoint: '/article',
    fromJson: Article.fromJson,
    toJson: (a) => a.toJson(),
    getId: (a) => a.id,
    getDisplayName: (a) => a.title,
    columns: const ['ID', 'Title', 'Description', 'Published'],
    matchesSearch: (a, q) =>
        a.id.toString().contains(q) ||
        a.title.toLowerCase().contains(q) ||
        a.description.toLowerCase().contains(q),
    matchesColumn: (a, col, v) {
      switch (col) {
        case 'ID':
          return a.id.toString().contains(v);
        case 'Title':
          return a.title.toLowerCase().contains(v);
        case 'Description':
          return a.description.toLowerCase().contains(v);
        case 'Published':
          return a.published.toString().contains(v);
        default:
          return true;
      }
    },
    sortValue: (a, i) {
      switch (i) {
        case 0:
          return a.id;
        case 1:
          return a.title;
        case 2:
          return a.description;
        case 3:
          return a.published.toString();
        default:
          return a.id;
      }
    },
    buildCells: (a) => [
      DataCell(Text('${a.id}')),
      DataCell(Text(a.title, overflow: TextOverflow.ellipsis)),
      DataCell(Text(a.description, overflow: TextOverflow.ellipsis)),
      DataCell(
        StatusBadge(
          active: a.published,
          trueLabel: 'Published',
          falseLabel: 'Draft',
        ),
      ),
    ],
    buildFormDialog: (ctx, existing, nextLocalId, onSubmit) =>
        _ArticleFormDialog(
          existing: existing,
          nextLocalId: nextLocalId,
          onSubmit: onSubmit,
        ),
    title: 'Articles',
    entityLabel: 'Article',
    onRowTap: (context, article) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailVU(article: article)),
    ),
    cardBuilder: (article, onEdit, onDelete) => Builder(
      builder: (context) => GenericCard(
        initial: article.title.isNotEmpty
            ? article.title[0].toUpperCase()
            : 'A',
        avatarBgColor: const Color(0xFFDDE1FF),
        avatarFgColor: const Color(0xFF001075),
        title: article.title,
        subtitle: article.description,
        titleTrailing: StatusBadge(
          active: article.published,
          trueLabel: 'Published',
          falseLabel: 'Draft',
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ArticleDetailVU(article: article)),
        ),
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    ),
    emptyIcon: Icons.article_outlined,
    emptyMessage: 'No articles found',
    extraActionsBuilder: extraActionsBuilder,
  );
}

class _ArticleFormDialog extends StatefulWidget {
  const _ArticleFormDialog({
    required this.existing,
    required this.nextLocalId,
    required this.onSubmit,
  });

  final Article? existing;
  final int nextLocalId;
  final Future<void> Function(Article) onSubmit;

  @override
  State<_ArticleFormDialog> createState() => _ArticleFormDialogState();
}

class _ArticleFormDialogState extends State<_ArticleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl = TextEditingController(
    text: widget.existing?.title ?? '',
  );
  late final _descCtrl = TextEditingController(
    text: widget.existing?.description ?? '',
  );
  late final _bodyCtrl = TextEditingController(
    text: widget.existing?.body ?? '',
  );
  late bool _published = widget.existing?.published ?? false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(
      Article(
        id: widget.existing?.id ?? widget.nextLocalId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
        published: _published,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final w = MediaQuery.sizeOf(context).width;
    final h = max(16.0, (w - 520) / 2);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: h, vertical: 24),
      title: Text(
        isEdit ? 'Edit Article #${widget.existing!.id}' : 'Add New Article',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.height,
              TextFormField(
                controller: _titleCtrl,
                decoration: _dec('Title', Icons.title_rounded),
                validator: (v) => v!.trim().isEmpty
                    ? 'Required'
                    : v.trim().length < 5
                    ? 'Length must be at least 5'
                    : null,
              ),
              12.height,
              TextFormField(
                controller: _descCtrl,
                decoration: _dec('Description', Icons.description_outlined),
                maxLines: 2,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              12.height,
              TextFormField(
                controller: _bodyCtrl,
                decoration: _dec('Body', Icons.article_outlined),
                maxLines: 4,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              4.height,
              SwitchListTile(
                title: const Text('Published'),
                value: _published,
                onChanged: (v) => setState(() => _published = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
          label: Text(isEdit ? 'Save Changes' : 'Add Article'),
        ),
      ],
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

Widget buildPeopleScreen() {
  return GenericDataTableVU<Person>(
    endpoint: '/people',
    fromJson: Person.fromJson,
    toJson: (p) => p.toJson(),
    getId: (p) => p.id,
    getDisplayName: (p) => p.name,
    columns: const ['ID', 'Name', 'Age', 'City', 'Email'],
    matchesSearch: (p, q) =>
        p.id.toString().contains(q) ||
        p.name.toLowerCase().contains(q) ||
        p.age.toString().contains(q) ||
        p.city.toLowerCase().contains(q) ||
        p.email.toLowerCase().contains(q),
    matchesColumn: (p, col, v) {
      switch (col) {
        case 'ID':
          return p.id.toString().contains(v);
        case 'Name':
          return p.name.toLowerCase().contains(v);
        case 'Age':
          return p.age.toString().contains(v);
        case 'City':
          return p.city.toLowerCase().contains(v);
        case 'Email':
          return p.email.toLowerCase().contains(v);
        default:
          return true;
      }
    },
    sortValue: (p, i) {
      switch (i) {
        case 0:
          return p.id;
        case 1:
          return p.name;
        case 2:
          return p.age;
        case 3:
          return p.city;
        case 4:
          return p.email;
        default:
          return p.id;
      }
    },
    buildCells: (p) => [
      DataCell(Text('${p.id}')),
      DataCell(Text(p.name)),
      DataCell(Text('${p.age}')),
      DataCell(Text(p.city)),
      DataCell(Text(p.email)),
    ],
    buildFormDialog: (ctx, existing, nextLocalId, onSubmit) =>
        _PersonFormDialog(
          existing: existing,
          nextLocalId: nextLocalId,
          onSubmit: onSubmit,
        ),
    title: 'People',
    entityLabel: 'Person',
    onRowTap: (context, person) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PersonDetailVU(person: person)),
    ),
    cardBuilder: (person, onEdit, onDelete) => Builder(
      builder: (context) {
        final tt = Theme.of(context).textTheme;
        return GenericCard(
          initial: person.name.isNotEmpty ? person.name[0].toUpperCase() : 'P',
          avatarBgColor: const Color(0xFFDCF5E7),
          avatarFgColor: const Color(0xFF00522A),
          title: person.name,
          subtitle: person.email,
          metadata: Row(
            children: [
              const Icon(
                Icons.location_city_outlined,
                size: 13,
                color: Color(0xFF74767F),
              ),
              3.width,
              Text(
                person.city,
                style: tt.bodySmall?.copyWith(color: const Color(0xFF74767F)),
              ),
              10.width,
              const Icon(
                Icons.cake_outlined,
                size: 13,
                color: Color(0xFF74767F),
              ),
              3.width,
              Text(
                '${person.age}',
                style: tt.bodySmall?.copyWith(color: const Color(0xFF74767F)),
              ),
            ],
          ),
          onEdit: onEdit,
          onDelete: onDelete,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonDetailVU(person: person),
            ),
          ),
        );
      },
    ),
    emptyIcon: Icons.people_outline,
    emptyMessage: 'No people found',
  );
}

class _PersonFormDialog extends StatefulWidget {
  const _PersonFormDialog({
    required this.existing,
    required this.nextLocalId,
    required this.onSubmit,
  });

  final Person? existing;
  final int nextLocalId;
  final Future<void> Function(Person) onSubmit;

  @override
  State<_PersonFormDialog> createState() => _PersonFormDialogState();
}

class _PersonFormDialogState extends State<_PersonFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(
    text: widget.existing?.name ?? '',
  );
  late final _ageCtrl = TextEditingController(
    text: widget.existing?.age.toString() ?? '',
  );
  late final _cityCtrl = TextEditingController(
    text: widget.existing?.city ?? '',
  );
  late final _emailCtrl = TextEditingController(
    text: widget.existing?.email ?? '',
  );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(
      Person(
        id: widget.existing?.id ?? widget.nextLocalId,
        name: _nameCtrl.text.trim(),
        age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
        city: _cityCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final w = MediaQuery.sizeOf(context).width;
    final h = max(16.0, (w - 520) / 2);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: h, vertical: 24),
      title: Text(
        isEdit ? 'Edit Person #${widget.existing!.id}' : 'Add New Person',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.height,
              TextFormField(
                controller: _nameCtrl,
                decoration: _dec('Name', Icons.person_outline),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              12.height,
              TextFormField(
                controller: _ageCtrl,
                decoration: _dec('Age', Icons.cake_outlined),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Must be a number';
                  return null;
                },
              ),
              12.height,
              TextFormField(
                controller: _cityCtrl,
                decoration: _dec('City', Icons.location_city_outlined),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              12.height,
              TextFormField(
                controller: _emailCtrl,
                decoration: _dec('Email', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              8.height,
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
          label: Text(isEdit ? 'Save Changes' : 'Add Person'),
        ),
      ],
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learning/data_table/api_client.dart';
import 'package:learning/data_table/extensions.dart';
import 'package:stacked/stacked.dart';

class GenericDataVM<T> extends BaseViewModel {
  GenericDataVM({
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
  }) {
    _load();
    scrollController.addListener(_scrollListener);
  }

  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final int Function(T) getId;
  final String Function(T) getDisplayName;
  final List<String> columns;
  final bool Function(T item, String query) matchesSearch;
  final bool Function(T item, String column, String value) matchesColumn;
  final Comparable Function(T item, int columnIndex) sortValue;
  final List<DataCell> Function(T item) buildCells;
  final Widget Function(
    BuildContext ctx,
    T? existing,
    int nextLocalId,
    Future<void> Function(T) onSubmit,
  )
  buildFormDialog;

  List<T> items = [];
  final scrollController = ScrollController();
  int page = 1;
  int pageSize = 10;
  int _total = 0;

  int? selectedColumnIndex;
  bool isAscending = false;
  String searchQuery = '';
  final Set<int> selectedIds = {};
  final Map<String, String> columnFilters = {};

  bool get hasNextPage => page * pageSize < _total;

  List<String> entityColumns = [];
  late String entityDisplayName;
  late int entityId;

  String get pageRangeLabel {
    if (_total == 0) return '';
    final start = (page - 1) * pageSize + 1;
    final end = min(page * pageSize, _total);
    return 'Showing $start–$end of $_total';
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || columnFilters.values.any((v) => v.isNotEmpty);

  List<T> get filteredItems {
    var result = items.toList();
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((i) => matchesSearch(i, q)).toList();
    }
    for (final entry in columnFilters.entries) {
      if (entry.value.isEmpty) continue;
      result = result
          .where((i) => matchesColumn(i, entry.key, entry.value.toLowerCase()))
          .toList();
    }
    return result;
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void clearAllFilters() {
    searchQuery = '';
    columnFilters.clear();
    notifyListeners();
  }

  void showColumnFilterDialog(BuildContext context, String column) {
    final controller = TextEditingController(text: columnFilters[column] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Filter by $column'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter filter value…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              columnFilters.remove(column);
              notifyListeners();
              Navigator.of(ctx).pop();
            },
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () {
              columnFilters[column] = controller.text.trim();
              notifyListeners();
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void sort(int columnIndex, bool ascending) {
    selectedColumnIndex = columnIndex;
    isAscending = ascending;
    items.sort((a, b) {
      final result = sortValue(
        a,
        columnIndex,
      ).compareTo(sortValue(b, columnIndex));
      return ascending ? result : -result;
    });
    notifyListeners();
  }

  List<DataColumn> getColumns(BuildContext context) => columns.map((col) {
    final isFiltered =
        columnFilters.containsKey(col) && columnFilters[col]!.isNotEmpty;
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(col),
          4.width,
          IconButton(
            onPressed: () => showColumnFilterDialog(context, col),
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            iconSize: 15,
            icon: Icon(
              isFiltered ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: isFiltered ? Colors.blue : null,
            ),
            tooltip: 'Filter $col',
          ),
        ],
      ),
      onSort: sort,
    );
  }).toList();

  List<DataRow> getRows(List<T> rows, {void Function(T)? onRowTap}) => rows
      .map(
        (item) => DataRow(
          selected: selectedIds.contains(getId(item)),
          onSelectChanged: (value) {
            if (value == true) {
              selectedIds.add(getId(item));
            } else {
              selectedIds.remove(getId(item));
            }
            notifyListeners();
          },
          cells: buildCells(item)
              .map(
                (cell) => DataCell(
                  cell.child,
                  placeholder: cell.placeholder,
                  showEditIcon: cell.showEditIcon,
                  onTap: onRowTap != null ? () => onRowTap(item) : cell.onTap,
                  onLongPress: cell.onLongPress,
                  onTapDown: cell.onTapDown,
                  onDoubleTap: cell.onDoubleTap,
                  onTapCancel: cell.onTapCancel,
                ),
              )
              .toList(),
        ),
      )
      .toList();

  Future<void> _load({bool append = false}) async {
    setBusy(true);
    try {
      final fetched = await ApiClient.instance.get<List<T>>(
        endpoint: endpoint,
        queryParams: {'page': page.toString(), 'pageSize': pageSize.toString()},
        fromJson: (json) => (json as List)
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      _total = ApiClient.totalItems;
      if (append) {
        items = {...items, ...fetched}.toList();
      } else {
        items = [...fetched];
      }
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Fetch failed ($endpoint): $e\n$stack');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refresh() {
    page = 1;
    return _load();
  }

  Future<void> loadNextPage() async {
    if (isBusy || !hasNextPage) return;
    page++;
    await _load();
  }

  Future<void> loadPrevPage() async {
    if (isBusy || page <= 1) return;
    page--;
    await _load();
  }

  void _scrollListener() {
    if (!scrollController.hasClients || isBusy || !hasNextPage) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      _load(append: true);
    }
  }

  Future<void> openDialog(BuildContext context) async {
    final nextId = items.isEmpty ? 1 : items.map(getId).reduce(max) + 1;
    await showDialog(
      context: context,
      builder: (ctx) =>
          buildFormDialog(ctx, null, nextId, (item) => _addItem(ctx, item)),
    );
  }

  Future<void> openEditDialog(BuildContext context, T item) async {
    final index = items.indexWhere((i) => getId(i) == getId(item));
    await showDialog(
      context: context,
      builder: (ctx) => buildFormDialog(
        ctx,
        item,
        getId(item),
        (updated) => _updateItem(ctx, index, item, updated),
      ),
    );
  }

  Future<void> _addItem(BuildContext ctx, T item) async {
    setBusy(true);
    try {
      final created = await ApiClient.instance.post<T>(
        endpoint: endpoint,
        body: toJson(item),
        fromJson: fromJson,
      );
      items.add(created);
      notifyListeners();
      if (ctx.mounted) Navigator.of(ctx).pop(true);
    } catch (e) {
      debugPrint('Create failed: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> _updateItem(
    BuildContext ctx,
    int index,
    T original,
    T updated,
  ) async {
    final originalMap = toJson(original);
    final updatedMap = toJson(updated);
    final patch = {
      for (final k in updatedMap.keys)
        if (k != 'id' && originalMap[k] != updatedMap[k]) k: updatedMap[k],
    };
    if (patch.isEmpty) {
      if (ctx.mounted) Navigator.of(ctx).pop(true);
      return;
    }
    setBusy(true);
    try {
      await ApiClient.instance.patch<T>(
        endpoint: endpoint,
        id: getId(original),
        changes: patch,
        fromJson: fromJson,
      );
      items[index] = updated;
      notifyListeners();
      if (ctx.mounted) Navigator.of(ctx).pop(true);
    } catch (e) {
      debugPrint('Update failed: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> confirmDelete(BuildContext context, T item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: Text(
          'Delete "${getDisplayName(item)}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setBusy(true);
    try {
      final deleted = await ApiClient.instance.delete(
        endpoint: endpoint,
        id: getId(item),
      );
      if (deleted) {
        items.removeWhere((i) => getId(i) == getId(item));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> confirmDeleteSelected(BuildContext context) async {
    if (selectedIds.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Selected'),
        content: Text(
          'Delete ${selectedIds.length} selected items? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setBusy(true);
    try {
      for (final id in selectedIds.toList()) {
        final deleted = await ApiClient.instance.delete(
          endpoint: endpoint,
          id: id,
        );
        if (deleted) items.removeWhere((i) => getId(i) == id);
      }
      selectedIds.clear();
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:learning/data_table/extensions.dart';

typedef CardBuilder<T> =
    Widget Function(T item, VoidCallback onEdit, VoidCallback onDelete);

class GenericDataScreen<T> extends StatelessWidget {
  const GenericDataScreen({
    super.key,
    required this.title,
    required this.entityLabel,
    required this.filteredItems,
    required this.isBusy,
    required this.scrollController,
    required this.searchQuery,
    required this.onSearch,
    required this.onRefresh,
    this.onClearFilters,
    required this.cardBuilder,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.columns,
    required this.rowsBuilder,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.page,
    required this.hasNextPage,
    required this.pageRangeLabel,
    required this.onNextPage,
    required this.onPrevPage,
    required this.onAdd,
    this.selectedCount = 0,
    this.canEdit = false,
    this.onEditSelected,
    this.canDelete = false,
    this.onDeleteSelected,
    this.deleteLabel = 'Delete selected',
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyMessage = 'No items found',
    this.extraActions = const [],
  });

  final String title;
  final String entityLabel;
  final List<T> filteredItems;
  final bool isBusy;
  final ScrollController scrollController;
  final String searchQuery;
  final void Function(String) onSearch;
  final VoidCallback onRefresh;
  final VoidCallback? onClearFilters;
  final CardBuilder<T> cardBuilder;
  final void Function(T) onEditItem;
  final void Function(T) onDeleteItem;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) rowsBuilder;
  final int? sortColumnIndex;
  final bool sortAscending;
  final int page;
  final bool hasNextPage;
  final String pageRangeLabel;
  final VoidCallback onNextPage;
  final VoidCallback onPrevPage;
  final VoidCallback onAdd;
  final int selectedCount;
  final bool canEdit;
  final VoidCallback? onEditSelected;
  final bool canDelete;
  final VoidCallback? onDeleteSelected;
  final String deleteLabel;
  final IconData emptyIcon;
  final String emptyMessage;
  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: onClearFilters != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Clear filters',
                onPressed: onClearFilters,
              )
            : null,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          ...extraActions,
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: isBusy ? null : onRefresh,
          ),
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text('Add $entityLabel'),
                onPressed: onAdd,
              ),
            ),
          if (isMobile) 4.width,
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text('Add $entityLabel'),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SearchBar(
                            onChanged: onSearch,
                            isMobile: isMobile,
                            searchQuery: searchQuery,
                          ),
                        ),
                        if (!isMobile) ...[
                          12.width,
                          _SelectionCountChip(count: selectedCount),
                        ],
                      ],
                    ),
                    if (!isMobile) ...[
                      8.height,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: canEdit ? onEditSelected : null,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit selected'),
                          ),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFBA1A1A),
                              disabledBackgroundColor: const Color(0xFFE7D6D6),
                              disabledForegroundColor: const Color(0xFF7D5D5D),
                            ),
                            onPressed: canDelete ? onDeleteSelected : null,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: Text(deleteLabel),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isBusy) const LinearProgressIndicator(minHeight: 2) else 2.height,
          Expanded(
            child: isBusy && filteredItems.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _DataView<T>(
                    filteredItems: filteredItems,
                    isMobile: isMobile,
                    isBusy: isBusy,
                    scrollController: scrollController,
                    cardBuilder: cardBuilder,
                    onEditItem: onEditItem,
                    onDeleteItem: onDeleteItem,
                    columns: columns,
                    rowsBuilder: rowsBuilder,
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    page: page,
                    hasNextPage: hasNextPage,
                    pageRangeLabel: pageRangeLabel,
                    onNextPage: onNextPage,
                    onPrevPage: onPrevPage,
                    onClearFilters: onClearFilters,
                    emptyIcon: emptyIcon,
                    emptyMessage: emptyMessage,
                  ),
          ),
        ],
      ),
    );
  }
}

class DataActionButton extends StatelessWidget {
  const DataActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.active,
    required this.trueLabel,
    required this.falseLabel,
  });

  final bool active;
  final String trueLabel;
  final String falseLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.green.shade600 : Colors.grey.shade400,
          width: 0.8,
        ),
      ),
      child: Text(
        active ? trueLabel : falseLabel,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active ? Colors.green.shade700 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class GenericCard extends StatelessWidget {
  const GenericCard({
    super.key,
    required this.initial,
    required this.avatarBgColor,
    required this.avatarFgColor,
    required this.title,
    this.subtitle,
    this.titleTrailing,
    this.metadata,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final String initial;
  final Color avatarBgColor;
  final Color avatarFgColor;
  final String title;
  final String? subtitle;
  final Widget? titleTrailing;
  final Widget? metadata;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarBgColor,
                foregroundColor: avatarFgColor,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (titleTrailing != null) ...[8.width, titleTrailing!],
                      ],
                    ),
                    if (subtitle != null) ...[
                      4.height,
                      Text(
                        subtitle!,
                        style: tt.bodySmall?.copyWith(
                          color: const Color(0xFF44464F),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (metadata != null) ...[2.height, metadata!],
                    6.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DataActionButton(
                          icon: Icons.edit_outlined,
                          color: const Color(0xFF4F6AF5),
                          tooltip: 'Edit',
                          onPressed: onEdit,
                        ),
                        4.width,
                        DataActionButton(
                          icon: Icons.delete_outline,
                          color: const Color(0xFFBA1A1A),
                          tooltip: 'Delete',
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataView<T> extends StatelessWidget {
  const _DataView({
    required this.filteredItems,
    required this.isMobile,
    required this.isBusy,
    required this.scrollController,
    required this.cardBuilder,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.columns,
    required this.rowsBuilder,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.page,
    required this.hasNextPage,
    required this.pageRangeLabel,
    required this.onNextPage,
    required this.onPrevPage,
    this.onClearFilters,
    required this.emptyIcon,
    required this.emptyMessage,
  });

  final List<T> filteredItems;
  final bool isMobile;
  final bool isBusy;
  final ScrollController scrollController;
  final CardBuilder<T> cardBuilder;
  final void Function(T) onEditItem;
  final void Function(T) onDeleteItem;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) rowsBuilder;
  final int? sortColumnIndex;
  final bool sortAscending;
  final int page;
  final bool hasNextPage;
  final String pageRangeLabel;
  final VoidCallback onNextPage;
  final VoidCallback onPrevPage;
  final VoidCallback? onClearFilters;
  final IconData emptyIcon;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      if (filteredItems.isEmpty) {
        return _EmptyState(
          onClearFilters: onClearFilters,
          icon: emptyIcon,
          message: emptyMessage,
        );
      }
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return cardBuilder(
            item,
            () => onEditItem(item),
            () => onDeleteItem(item),
          );
        },
      );
    }

    final isEmpty = filteredItems.isEmpty;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          
        }
        final rows = isEmpty ? <DataRow>[] : rowsBuilder(filteredItems);
        final dataTable = ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            showCheckboxColumn: true,
            columnSpacing: 48,
            horizontalMargin: 24,
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            columns: columns,
            rows: rows,
          ),
        );

        final paginationRow = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous page',
                onPressed: page > 1 && !isBusy ? onPrevPage : null,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Page $page',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (pageRangeLabel.isNotEmpty)
                    Text(
                      pageRangeLabel,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next page',
                onPressed: hasNextPage && !isBusy ? onNextPage : null,
              ),
            ],
          ),
        );

        if (isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: dataTable,
              ),
              Expanded(
                child: _EmptyState(
                  onClearFilters: onClearFilters,
                  icon: emptyIcon,
                  message: emptyMessage,
                ),
              ),
              paginationRow,
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    showCheckboxColumn: true,
                    columnSpacing: 48,
                    horizontalMargin: 24,
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    columns: columns,
                    rows: rows,
                  ),
                ),
              ),
            ),
            paginationRow,
          ],
        );
      },
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.onChanged,
    required this.isMobile,
    required this.searchQuery,
  });

  final void Function(String) onChanged;
  final bool isMobile;
  final String searchQuery;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(_SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.isMobile ? 12 : 24,
        12,
        widget.isMobile ? 12 : 24,
        8,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Search…',
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: const Color(0xFFE8E9F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF4F6AF5), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _SelectionCountChip extends StatelessWidget {
  const _SelectionCountChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final hasSelection = count > 0;
    return Chip(
      avatar: Icon(
        hasSelection ? Icons.check_circle_outline : Icons.info_outline,
        size: 18,
        color: hasSelection ? const Color(0xFF4F6AF5) : const Color(0xFF74767F),
      ),
      label: Text(
        hasSelection ? '$count selected' : 'No rows selected',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: hasSelection
              ? const Color(0xFF1F2A5A)
              : const Color(0xFF74767F),
        ),
      ),
      backgroundColor: hasSelection
          ? const Color(0xFFE7ECFF)
          : const Color(0xFFF1F2F6),
      side: BorderSide(
        color: hasSelection ? const Color(0xFFC6D1FF) : const Color(0xFFD8DAE4),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    this.onClearFilters,
    required this.icon,
    required this.message,
  });

  final VoidCallback? onClearFilters;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: const Color(0xFFC4C6D0)),
          16.height,
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF44464F),
              fontWeight: FontWeight.w600,
            ),
          ),
          6.height,
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF74767F)),
          ),
          if (onClearFilters != null) ...[
            16.height,
            TextButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
              label: const Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }
}

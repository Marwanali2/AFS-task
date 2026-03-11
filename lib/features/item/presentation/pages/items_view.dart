import 'package:afs_task/core/network/network_cubit.dart';
import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/presentation/bloc/item_bloc.dart';
import 'package:afs_task/features/item/presentation/bloc/item_event.dart';
import 'package:afs_task/features/item/presentation/bloc/item_state.dart';
import 'package:afs_task/features/item/presentation/pages/empty_view.dart';
import 'package:afs_task/features/item/presentation/pages/filtered_empty_view.dart';
import 'package:afs_task/features/item/presentation/pages/loading_view.dart';
import 'package:afs_task/features/item/presentation/widgets/item_card.dart';
import 'package:afs_task/features/item/presentation/widgets/item_form_bottom_sheet.dart';
import 'package:afs_task/features/item/presentation/widgets/items_filter_bottom_sheet.dart';
import 'package:afs_task/features/item/presentation/widgets/items_selection_app_bar.dart';
import 'package:afs_task/features/item/presentation/widgets/items_sort_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => ItemsViewState();
}

class ItemsViewState extends State<ItemsView> {
  SortOrder _sortOrder = SortOrder.newestFirst;
  bool _showEdited = true;
  bool _showNotEdited = true;
  final Set<int> _selectedIds = {};
  bool get _selectionMode => _selectedIds.isNotEmpty;

  void _toggleSelectionFor(Item item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _resetFilters() {
    setState(() {
      _sortOrder = SortOrder.newestFirst;
      _showEdited = true;
      _showNotEdited = true;
    });
  }

  void _openForm(BuildContext context, {Item? item}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ItemFormBottomSheet(
        initialItem: item,
        onSubmit: (name, description) async {
          final bloc = context.read<ItemBloc>();
          if (item == null) {
            bloc.add(CreateItemEvent(name: name, description: description));
          } else {
            bloc.add(
              UpdateItemEvent(
                Item(
                  id: item.id,
                  name: name,
                  description: description,
                  isEdited: item.isEdited,
                  createdAt: item.createdAt,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _openFilterSheet(BuildContext context, List<Item> allItems) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ItemsFilterBottomSheet(
        currentSortOrder: _sortOrder,
        showEdited: _showEdited,
        showNotEdited: _showNotEdited,
        editedCount: allItems.where((e) => e.isEdited).length,
        notEditedCount: allItems.where((e) => !e.isEdited).length,
        onApply: (sortOrder, showEdited, showNotEdited) {
          setState(() {
            _sortOrder = sortOrder;
            _showEdited = showEdited;
            _showNotEdited = showNotEdited;
          });
        },
        onReset: _resetFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<NetworkCubit, NetworkState>(
      listenWhen: (previous, current) =>
          previous.isConnected != current.isConnected,
      listener: (context, netState) {
        final message = netState.isConnected ? 'Back online' : 'No internet connection';
        final color = netState.isConnected 
            ? theme.colorScheme.primaryContainer 
            : theme.colorScheme.errorContainer;
        final onColor = netState.isConnected 
            ? theme.colorScheme.onPrimaryContainer 
            : theme.colorScheme.onErrorContainer;
        final icon = netState.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: color,
            content: Row(
              children: [
                Icon(icon, color: onColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: netState.isConnected 
                        ? AppTextStyles.successStyle(context) 
                        : AppTextStyles.errorStyle(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: BlocConsumer<ItemBloc, ItemState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.infoMessage != current.infoMessage,
        listener: (context, state) {
          final message = state.errorMessage ?? state.infoMessage;
          if (message != null && message.isNotEmpty) {
            final isError = state.errorMessage != null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: isError ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
                content: Row(
                  children: [
                    Icon(
                      isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                      color: isError ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: isError 
                            ? AppTextStyles.errorStyle(context) 
                            : AppTextStyles.successStyle(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final allItems = state.items;
          var visibleItems = allItems.where((item) {
            if (!_showEdited && item.isEdited) return false;
            if (!_showNotEdited && !item.isEdited) return false;
            return true;
          }).toList();

          if (_sortOrder == SortOrder.oldestFirst) {
            visibleItems = visibleItems.reversed.toList();
          }

          final selectedCount = _selectedIds.length;
          final allVisibleSelected = visibleItems.isNotEmpty &&
              visibleItems.every((item) => _selectedIds.contains(item.id));

          return Scaffold(
            appBar: ItemsSelectionAppBar(
              selectionMode: _selectionMode,
              selectedCount: selectedCount,
              allVisibleSelected: allVisibleSelected,
              onClearSelection: _clearSelection,
              onToggleSelectAll: () {
                setState(() {
                  if (allVisibleSelected) {
                    for (final item in visibleItems) {
                      _selectedIds.remove(item.id);
                    }
                  } else {
                    for (final item in visibleItems) {
                      _selectedIds.add(item.id);
                    }
                  }
                });
              },
              onDeleteSelected: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete selected items?'),
                    content: Text('This will delete $selectedCount item(s). This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                      FilledButton.tonal(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (confirmed == true) {
                  if (!context.mounted) return;
                  context.read<ItemBloc>().add(DeleteMultipleItemsEvent(_selectedIds.toList()));
                  _clearSelection();
                }
              },
              onOpenFilter: () => _openFilterSheet(context, allItems),
              isFilterEnabled: allItems.isNotEmpty,
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: state.isLoading && allItems.isEmpty
                  ? const LoadingView(key: ValueKey('loading'))
                  : allItems.isEmpty
                      ? const EmptyView(key: ValueKey('empty'))
                      : visibleItems.isEmpty
                          ? FilteredEmptyView(
                              key: const ValueKey('filtered_empty'),
                              onResetFilters: _resetFilters,
                            )
                          : ListView.separated(
                              key: const ValueKey('items_list'),
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                              itemBuilder: (context, index) {
                                final item = visibleItems[index];
                                final isSelected = _selectedIds.contains(item.id);
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.96, end: 1.0),
                                  duration: Duration(milliseconds: 160 + (index * 24)),
                                  curve: Curves.easeOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                                    );
                                  },
                                  child: ItemCard(
                                    item: item,
                                    selectionMode: _selectionMode,
                                    isSelected: isSelected,
                                    onToggleSelected: () => _toggleSelectionFor(item),
                                    onEdit: () => _openForm(context, item: item),
                                    onDelete: () => context.read<ItemBloc>().add(DeleteItemEvent(item.id)),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemCount: visibleItems.length,
                            ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Add item'),
            ),
          );
        },
      ),
    );
  }
}

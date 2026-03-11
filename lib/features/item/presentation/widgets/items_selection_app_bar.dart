import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:afs_task/core/network/network_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsSelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool selectionMode;
  final int selectedCount;
  final bool allVisibleSelected;
  final VoidCallback onClearSelection;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onDeleteSelected;
  final VoidCallback onOpenFilter;
  final bool isFilterEnabled;

  const ItemsSelectionAppBar({
    super.key,
    required this.selectionMode,
    required this.selectedCount,
    required this.allVisibleSelected,
    required this.onClearSelection,
    required this.onToggleSelectAll,
    required this.onDeleteSelected,
    required this.onOpenFilter,
    required this.isFilterEnabled,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      leading: selectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClearSelection,
            )
          : null,
      title: selectionMode
          ? Text('$selectedCount selected', style: AppTextStyles.titleMedium(context))
          : Row(
              children: [
                Text('My items', style: AppTextStyles.titleMedium(context)),
                const SizedBox(width: 8),
                BlocBuilder<NetworkCubit, NetworkState>(
                  builder: (context, netState) {
                    if (netState.isConnected) {
                      return const SizedBox.shrink();
                    }
                    return Tooltip(
                      message: 'Offline',
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  },
                ),
              ],
            ),
      centerTitle: false,
      actions: selectionMode
          ? [
              IconButton(
                icon: Icon(
                  allVisibleSelected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                ),
                tooltip: allVisibleSelected ? 'Unselect all' : 'Select all',
                onPressed: onToggleSelectAll,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete selected',
                onPressed: onDeleteSelected,
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                tooltip: 'Filter & sort',
                onPressed: isFilterEnabled ? onOpenFilter : null,
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

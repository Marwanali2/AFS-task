import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:afs_task/features/item/presentation/widgets/items_sort_order.dart';
import 'package:flutter/material.dart';

class ItemsFilterBottomSheet extends StatefulWidget {
  final SortOrder currentSortOrder;
  final bool showEdited;
  final bool showNotEdited;
  final int editedCount;
  final int notEditedCount;
  final void Function(SortOrder sortOrder, bool showEdited, bool showNotEdited) onApply;
  final VoidCallback onReset;

  const ItemsFilterBottomSheet({
    super.key,
    required this.currentSortOrder,
    required this.showEdited,
    required this.showNotEdited,
    required this.editedCount,
    required this.notEditedCount,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<ItemsFilterBottomSheet> createState() => _ItemsFilterBottomSheetState();
}

class _ItemsFilterBottomSheetState extends State<ItemsFilterBottomSheet> {
  late SortOrder _localSortOrder;
  late bool _localShowEdited;
  late bool _localShowNotEdited;

  @override
  void initState() {
    super.initState();
    _localSortOrder = widget.currentSortOrder;
    _localShowEdited = widget.showEdited;
    _localShowNotEdited = widget.showNotEdited;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters & sort',
                style: AppTextStyles.titleLarge(context),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sort by',
            style: AppTextStyles.titleSmall(context),
          ),
          RadioListTile<SortOrder>(
            value: SortOrder.newestFirst,
            groupValue: _localSortOrder,
            title: const Text('Newest first'),
            onChanged: (value) {
              setState(() {
                _localSortOrder = value ?? SortOrder.newestFirst;
              });
            },
          ),
          RadioListTile<SortOrder>(
            value: SortOrder.oldestFirst,
            groupValue: _localSortOrder,
            title: const Text('Oldest first'),
            onChanged: (value) {
              setState(() {
                _localSortOrder = value ?? SortOrder.oldestFirst;
              });
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Filter by',
            style: AppTextStyles.titleSmall(context),
          ),
          CheckboxListTile(
            value: _localShowEdited,
            onChanged: (value) {
              setState(() {
                _localShowEdited = value ?? false;
              });
            },
            title: Text('Edited items (${widget.editedCount})'),
          ),
          CheckboxListTile(
            value: _localShowNotEdited,
            onChanged: (value) {
              setState(() {
                _localShowNotEdited = value ?? false;
              });
            },
            title: Text('Not edited items (${widget.notEditedCount})'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_localSortOrder, _localShowEdited, _localShowNotEdited);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

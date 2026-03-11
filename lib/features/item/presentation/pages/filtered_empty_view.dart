import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class FilteredEmptyView extends StatelessWidget {
  final VoidCallback onResetFilters;


  const FilteredEmptyView({super.key, required this.onResetFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'No items match your filters',
              style: AppTextStyles.titleMedium(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting or resetting the filters to see more items.',
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onResetFilters,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}

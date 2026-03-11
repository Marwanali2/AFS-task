import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 72,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No items yet',
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the + button to add your first item.',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

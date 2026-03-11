import 'package:afs_task/core/theme/app_text_styles.dart';
import 'package:afs_task/core/utils/app_validators.dart';
import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:flutter/material.dart';

class ItemFormBottomSheet extends StatefulWidget {
  final Item? initialItem;
  final Future<void> Function(String name, String description) onSubmit;

  const ItemFormBottomSheet({
    super.key,
    this.initialItem,
    required this.onSubmit,
  });

  @override
  State<ItemFormBottomSheet> createState() => _ItemFormBottomSheetState();
}

class _ItemFormBottomSheetState extends State<ItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name);
    _descriptionController =
        TextEditingController(text: widget.initialItem?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (widget.initialItem != null) {
      final newName = _nameController.text.trim();
      final newDescription = _descriptionController.text.trim();
      final hasNameChanged = newName != widget.initialItem!.name;
      final hasDescriptionChanged =
          newDescription != widget.initialItem!.description;

      if (!hasNameChanged && !hasDescriptionChanged) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: theme.colorScheme.surfaceVariant,
            content: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No changes to save.',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ),
              ],
            ),
          ),
        );
        Navigator.of(context).pop();
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.initialItem == null ? 'Add item' : 'Edit item',
                    style: AppTextStyles.titleLarge(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter item name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: AppValidators.validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional details',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _handleSubmit,
                icon: _isSubmitting
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(widget.initialItem == null ? 'Add' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


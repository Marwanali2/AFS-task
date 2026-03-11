import 'package:afs_task/core/di/service_locator.dart';
import 'package:afs_task/features/item/presentation/bloc/item_bloc.dart';
import 'package:afs_task/features/item/presentation/bloc/item_event.dart';
import 'package:afs_task/features/item/presentation/pages/items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemBloc>(
      create: (_) => sl<ItemBloc>()..add(const LoadItemsEvent()),
      child: const ItemsView(),
    );
  }
}

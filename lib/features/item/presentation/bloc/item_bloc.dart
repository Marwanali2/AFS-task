import 'dart:async';

import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/domain/usecases/create_item.dart';
import 'package:afs_task/features/item/domain/usecases/delete_item.dart';
import 'package:afs_task/features/item/domain/usecases/get_items.dart';
import 'package:afs_task/features/item/domain/usecases/update_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetItems getItems;
  final CreateItem createItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;

  ItemBloc({
    required this.getItems,
    required this.createItem,
    required this.updateItem,
    required this.deleteItem,
  }) : super(ItemState.initial()) {
    on<LoadItemsEvent>(_onLoadItems);
    on<CreateItemEvent>(_onCreateItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
    on<DeleteMultipleItemsEvent>(_onDeleteMultipleItems);
  }

  Future<void> _onLoadItems(
    LoadItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, infoMessage: null));
    try {
      final items = await getItems();
      emit(
        state.copyWith(
          isLoading: false,
          items: items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load items',
        ),
      );
    }
  }

  Future<void> _onCreateItem(
    CreateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    if (event.name.trim().isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Name is required',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, infoMessage: null));

    try {
      final item = await createItem(event.name.trim(), event.description.trim());
      final updatedItems = [item, ...state.items];
      emit(
        state.copyWith(
          isLoading: false,
          items: updatedItems,
          infoMessage: 'Item added',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to add item',
        ),
      );
    }
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    final newName = event.item.name.trim();
    if (newName.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Name is required',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, infoMessage: null));

    try {
      final updatedItem = await updateItem(
        Item(
          id: event.item.id,
          name: newName,
          description: event.item.description.trim(),
          isEdited: event.item.isEdited,
          createdAt: event.item.createdAt,
        ),
      );
      final updatedItems = state.items
          .map((e) => e.id == updatedItem.id ? updatedItem : e)
          .toList();
      emit(
        state.copyWith(
          isLoading: false,
          items: updatedItems,
          infoMessage: 'Item updated',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update item',
        ),
      );
    }
  }

  Future<void> _onDeleteItem(
    DeleteItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, infoMessage: null));

    try {
      await deleteItem(event.id);
      final updatedItems =
          state.items.where((element) => element.id != event.id).toList();
      emit(
        state.copyWith(
          isLoading: false,
          items: updatedItems,
          infoMessage: 'Item deleted',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete item',
        ),
      );
    }
  }

  Future<void> _onDeleteMultipleItems(
    DeleteMultipleItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    if (event.ids.isEmpty) return;
    
    emit(state.copyWith(isLoading: true, errorMessage: null, infoMessage: null));

    try {
      bool anyFailure = false;
      final List<int> successfullyDeleted = [];

      for (final id in event.ids) {
        try {
          await deleteItem(id);
          successfullyDeleted.add(id);
        } catch (e) {
          anyFailure = true;
        }
      }
      
      final updatedItems = state.items
          .where((element) => !successfullyDeleted.contains(element.id))
          .toList();
          
      emit(
        state.copyWith(
          isLoading: false,
          items: updatedItems,
          infoMessage: anyFailure 
              ? 'Some items failed to delete' 
              : '${successfullyDeleted.length} items deleted',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete items',
        ),
      );
    }
  }
}

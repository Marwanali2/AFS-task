import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemsEvent extends ItemEvent {
  const LoadItemsEvent();
}

class CreateItemEvent extends ItemEvent {
  final String name;
  final String description;

  const CreateItemEvent({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

class UpdateItemEvent extends ItemEvent {
  final Item item;

  const UpdateItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteItemEvent extends ItemEvent {
  final int id;

  const DeleteItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteMultipleItemsEvent extends ItemEvent {
  final List<int> ids;

  const DeleteMultipleItemsEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}


import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:equatable/equatable.dart';

class ItemState extends Equatable {
  final List<Item> items;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;

  const ItemState({
    required this.items,
    required this.isLoading,
    this.errorMessage,
    this.infoMessage,
  });

  factory ItemState.initial() => const ItemState(
        items: [],
        isLoading: false,
      );

  ItemState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? errorMessage,
    String? infoMessage,
  }) {
    return ItemState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage, infoMessage];
}


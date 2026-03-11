import 'package:afs_task/features/item/domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.isEdited,
    required super.createdAt,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    final rawCreated = map['created_at'] as String?;
    final createdAt = rawCreated == null || rawCreated.isEmpty
        ? DateTime.now()
        : DateTime.tryParse(rawCreated) ?? DateTime.now();

    return ItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      isEdited: (map['is_edited'] as int?) == 1,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_edited': isEdited ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ItemModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isEdited,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


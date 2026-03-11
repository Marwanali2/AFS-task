import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int id;
  final String name;
  final String description;
  final bool isEdited;
  final DateTime createdAt;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.isEdited,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, isEdited, createdAt];
}


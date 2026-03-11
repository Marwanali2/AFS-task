import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/domain/repositories/item_repository.dart';

class CreateItem {
  final ItemRepository repository;

  CreateItem(this.repository);

  Future<Item> call(String name, String description) {
    return repository.createItem(name, description);
  }
}

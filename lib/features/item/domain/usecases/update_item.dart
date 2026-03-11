import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/domain/repositories/item_repository.dart';

class UpdateItem {
  final ItemRepository repository;

  UpdateItem(this.repository);

  Future<Item> call(Item item) {
    return repository.updateItem(item);
  }
}

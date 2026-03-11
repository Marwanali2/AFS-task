import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/domain/repositories/item_repository.dart';

class GetItems {
  final ItemRepository repository;

  GetItems(this.repository);

  Future<List<Item>> call() {
    return repository.getItems();
  }
}

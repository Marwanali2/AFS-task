import 'package:afs_task/features/item/domain/repositories/item_repository.dart';

class DeleteItem {
  final ItemRepository repository;

  DeleteItem(this.repository);

  Future<void> call(int id) {
    return repository.deleteItem(id);
  }
}

import 'package:afs_task/features/item/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems();
  Future<Item> createItem(String name, String description);
  Future<Item> updateItem(Item item);
  Future<void> deleteItem(int id);
}


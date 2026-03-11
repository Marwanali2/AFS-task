import 'package:afs_task/features/item/data/data_sources/item_local_data_source.dart';
import 'package:afs_task/features/item/data/models/item_model.dart';
import 'package:afs_task/features/item/domain/entities/item.dart';
import 'package:afs_task/features/item/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemLocalDataSource localDataSource;

  ItemRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Item>> getItems() async {
    return await localDataSource.getItems();
  }

  @override
  Future<Item> createItem(String name, String description) async {
    final newItem = ItemModel(
      id: 0,
      name: name,
      description: description,
      isEdited: false,
      createdAt: DateTime.now(),
    );

    return await localDataSource.insertItem(newItem);
  }

  @override
  Future<Item> updateItem(Item item) async {
    final model = ItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      isEdited: true,
      createdAt: item.createdAt,
    );
    return await localDataSource.updateItem(model);
  }

  @override
  Future<void> deleteItem(int id) async {
    await localDataSource.deleteItem(id);
  }
}


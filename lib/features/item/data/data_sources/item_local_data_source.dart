import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/item_model.dart';

abstract class ItemLocalDataSource {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> insertItem(ItemModel item);
  Future<ItemModel> updateItem(ItemModel item);
  Future<void> deleteItem(int id);
}

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  static const _dbName = 'items.db';
  static const _dbVersion = 3;
  static const _tableName = 'items';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            is_edited INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $_tableName ADD COLUMN created_at TEXT',
          );
          await db.rawUpdate(
            "UPDATE $_tableName SET created_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') WHERE created_at IS NULL",
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE $_tableName ADD COLUMN is_edited INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return maps.map(ItemModel.fromMap).toList();
  }

  @override
  Future<ItemModel> insertItem(ItemModel item) async {
    final db = await database;
    final id = await db.insert(_tableName, item.toMap()..remove('id'));
    return item.copyWith(id: id);
  }

  @override
  Future<ItemModel> updateItem(ItemModel item) async {
    final db = await database;
    await db.update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    return item;
  }

  @override
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


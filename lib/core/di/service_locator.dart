import 'package:afs_task/core/network/network_cubit.dart';
import 'package:afs_task/features/item/data/data_sources/item_local_data_source.dart';
import 'package:afs_task/features/item/data/repositories/item_repository_impl.dart';
import 'package:afs_task/features/item/domain/repositories/item_repository.dart';
import 'package:afs_task/features/item/domain/usecases/create_item.dart';
import 'package:afs_task/features/item/domain/usecases/delete_item.dart';
import 'package:afs_task/features/item/domain/usecases/get_items.dart';
import 'package:afs_task/features/item/domain/usecases/update_item.dart';
import 'package:afs_task/features/item/presentation/bloc/item_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Features - Item
  
  // Bloc
  sl.registerFactory(
    () => ItemBloc(
      getItems: sl(),
      createItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetItems(sl()));
  sl.registerLazySingleton(() => CreateItem(sl()));
  sl.registerLazySingleton(() => UpdateItem(sl()));
  sl.registerLazySingleton(() => DeleteItem(sl()));

  // Repository
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton(() => NetworkCubit());
}

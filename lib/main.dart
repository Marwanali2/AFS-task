import 'package:afs_task/core/di/service_locator.dart';
import 'package:afs_task/core/network/network_cubit.dart';
import 'package:afs_task/features/item/presentation/pages/items_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
      ),
    );

    return MaterialApp(
      title: 'Items Manager',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: BlocProvider(
        create: (_) => sl<NetworkCubit>(),
        child: const ItemsPage(),
      ),
    );
  }
}

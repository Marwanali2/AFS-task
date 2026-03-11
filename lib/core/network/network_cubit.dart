import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkState extends Equatable {
  final bool isConnected;

  const NetworkState({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const NetworkState(isConnected: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _emitFromResults(results);

      _subscription =
          _connectivity.onConnectivityChanged.listen(_emitFromResults);
    } catch (_) {
      // If the connectivity plugin is not available (e.g. web, tests, or
      // plugin not registered yet), fall back to "connected" so the app
      // doesn't crash.
      emit(const NetworkState(isConnected: true));
    }
  }

  void _emitFromResults(List<ConnectivityResult> results) {
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);
    final connected = hasConnection;
    emit(NetworkState(isConnected: connected));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}


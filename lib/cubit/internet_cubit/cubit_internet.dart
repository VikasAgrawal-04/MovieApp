import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/cubit/internet_cubit/internet_states.dart';

class InternetCubit extends Cubit<InternetState>{
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetCubit() : super(InternetInitialState()){
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      if(result== ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        emit(InternetStateActive());
      }
      else{
        emit(InternetStateInactive());
      }

    });
  }
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }

}
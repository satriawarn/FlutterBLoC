import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/app.dart';
import 'package:flutter_state_bloc/counter_observer.dart';

void main() {
  Bloc.observer = CounterObserver();
  runApp(const CounterApp());
}

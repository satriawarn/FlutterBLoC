import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/screens/favorites.dart';
import 'package:provider/provider.dart';

import 'package:flutter_state_bloc/models/favorites.dart';

import 'screens/home.dart';

void main() {
  runApp(const TestingApp());
}

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        title: 'Testing Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          FavoritePage.routeName: (context) => const FavoritePage(),
        },
        initialRoute: HomePage.routeName,
      ),
    );
  }
}

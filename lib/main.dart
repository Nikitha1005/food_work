import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/food_item.dart';
import 'models/restaurant.dart';
import 'blocs/order_bloc.dart';
import 'screens/order_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => OrderBloc(),
      child: const FoodOrderApp(),
    ),
  );
}

class FoodOrderApp extends StatelessWidget {
  const FoodOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = [
      Restaurant(
        id: "1",
        name: "Pizza Palace",
        menu: [
          FoodItem(id: "1", name: "Margherita", price: 199),
          FoodItem(id: "2", name: "Farmhouse", price: 249),
        ],
      ),
      Restaurant(
        id: "2",
        name: "Burger House",
        menu: [
          FoodItem(id: "3", name: "Veg Burger", price: 149),
          FoodItem(id: "4", name: "Cheese Burger", price: 179),
        ],
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: OrderScreen(restaurants: restaurants),
    );
  }
}

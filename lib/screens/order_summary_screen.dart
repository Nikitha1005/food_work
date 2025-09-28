import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/food_item.dart';
import '../blocs/order_bloc.dart';

class OrderSummaryScreen extends StatelessWidget {
  final List<FoodItem> items;
  final String restaurantName;

  const OrderSummaryScreen({
    super.key,
    required this.items,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Restaurant: $restaurantName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // List of ordered items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item.name),
                      trailing: Text("₹${item.price.toStringAsFixed(2)}"),
                    ),
                  );
                },
              ),
            ),

            // Total
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Total: ₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Back to restaurants button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                // Reset order so cart is cleared
                context.read<OrderBloc>().add(ResetOrder());

                // Navigate all the way back to restaurants
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                "Back to Restaurants",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

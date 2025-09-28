import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_bloc.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../widgets/restaurant_tile.dart';
import '../widgets/food_tile.dart';

class OrderScreen extends StatelessWidget {
  final List<Restaurant> restaurants;
  const OrderScreen({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Order Workflow")),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          } else if (state is OrderSuccess) {
            // Show popup dialog for "Order Placed!"
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      "Order Placed!",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );

            // Auto-close dialog and navigate to Order Summary
            Future.delayed(const Duration(minutes:1), () {
              Navigator.of(context).pop(); // Close the popup
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderSummaryScreen(
                    restaurant: state.restaurant!,
                    cart: state.cart,
                  ),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          if (state is OrderInitial) {
            return ListView(
              padding: const EdgeInsets.all(12),
              children: restaurants
                  .map((r) => RestaurantTile(
                restaurant: r,
                onTap: () =>
                    context.read<OrderBloc>().add(SelectRestaurant(r)),
              ))
                  .toList(),
            );
          } else if (state is OrderInProgress) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrange.shade200,
                        Colors.deepOrange.shade100
                      ],
                    ),
                  ),
                  child: Text(
                    "Restaurant: ${state.restaurant?.name ?? ''}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: state.restaurant!.menu
                        .map((f) => FoodTile(
                      item: f,
                      onAdd: () =>
                          context.read<OrderBloc>().add(AddItemToCart(f)),
                      onRemove: () => context
                          .read<OrderBloc>()
                          .add(RemoveItemFromCart(f)),
                    ))
                        .toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 8,
                          offset: const Offset(0, -3))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Items: ${state.cart.length}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            "Total: ₹${state.cart.fold(0.0, (s, i) => s + i.price).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.deepOrange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: state.cart.isEmpty
                              ? null
                              : () => context.read<OrderBloc>().add(PlaceOrder()),
                          child: const Text(
                            "Place Order",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Workflow complete"));
        },
      ),
    );
  }
}

// -------------------
// Order Summary Screen
// -------------------

class OrderSummaryScreen extends StatelessWidget {
  final Restaurant restaurant;
  final List<FoodItem> cart;
  const OrderSummaryScreen({
    super.key,
    required this.restaurant,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final total = cart.fold(0.0, (sum, item) => sum + item.price);
    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Restaurant: ${restaurant.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (_, i) {
                  final item = cart[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item.name),
                      trailing: Text(
                        "₹${item.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:", style: TextStyle(fontSize: 18)),
                Text(
                  "₹${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context.read<OrderBloc>().add(ResetOrder());
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child:
                const Text("Back to Restaurants", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

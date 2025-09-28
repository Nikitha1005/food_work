import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodTile extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const FoodTile({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(item.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("₹${item.price.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.black87)),
        trailing: SizedBox(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onRemove,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: onAdd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

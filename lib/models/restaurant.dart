import 'food_item.dart';

class Restaurant {
  final String id;
  final String name;
  final List<FoodItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.menu,
  });
}

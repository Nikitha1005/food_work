import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:food_order/blocs/order_bloc.dart';
import 'package:food_order/models/food_item.dart';
import 'package:food_order/models/restaurant.dart';

void main() {
  final pizza = FoodItem(id: "1", name: "Pizza", price: 200);
  final restaurant = Restaurant(id: "r1", name: "TestResto", menu: [pizza]);

  blocTest<OrderBloc, OrderState>(
    'emits OrderInProgress when restaurant selected',
    build: () => OrderBloc(),
    act: (bloc) => bloc.add(SelectRestaurant(restaurant)),
    expect: () => [isA<OrderInProgress>()],
  );

  blocTest<OrderBloc, OrderState>(
    'emits OrderSuccess when order placed with items',
    build: () => OrderBloc(),
    act: (bloc) {
      bloc.add(SelectRestaurant(restaurant));
      bloc.add(AddItemToCart(pizza));
      bloc.add(PlaceOrder());
    },
    skip: 2, // skip intermediate states
    expect: () => [isA<OrderSuccess>()],
  );

  blocTest<OrderBloc, OrderState>(
    'emits OrderFailure when placing order with empty cart',
    build: () => OrderBloc(),
    act: (bloc) {
      bloc.add(SelectRestaurant(restaurant));
      bloc.add(PlaceOrder());
    },
    skip: 1, // skip initial progress state
    expect: () => [isA<OrderFailure>()],
  );
}

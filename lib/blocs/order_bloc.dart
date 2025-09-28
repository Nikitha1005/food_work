import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends OrderEvent {
  final List<Restaurant> restaurants;
  LoadRestaurants(this.restaurants);
  @override
  List<Object?> get props => [restaurants];
}

class SelectRestaurant extends OrderEvent {
  final Restaurant restaurant;
  SelectRestaurant(this.restaurant);
  @override
  List<Object?> get props => [restaurant];
}

class AddItemToCart extends OrderEvent {
  final FoodItem item;
  AddItemToCart(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItemFromCart extends OrderEvent {
  final FoodItem item;
  RemoveItemFromCart(this.item);
  @override
  List<Object?> get props => [item];
}

class PlaceOrder extends OrderEvent {}

class ResetOrder extends OrderEvent {}

/// -------- STATES ----------

abstract class OrderState extends Equatable {
  final List<Restaurant> restaurants;
  const OrderState({this.restaurants = const []});

  @override
  List<Object?> get props => [restaurants];
}

class OrderInitial extends OrderState {
  const OrderInitial({List<Restaurant> restaurants = const []})
      : super(restaurants: restaurants);
}

class OrderInProgress extends OrderState {
  final Restaurant? restaurant;
  final List<FoodItem> cart;

  const OrderInProgress({
    required List<Restaurant> restaurants,
    this.restaurant,
    this.cart = const [],
  }) : super(restaurants: restaurants);

  @override
  List<Object?> get props => [restaurants, restaurant ?? '', cart];
}

class OrderSuccess extends OrderState {
  final Restaurant restaurant;
  final List<FoodItem> cart;

  const OrderSuccess({
    required List<Restaurant> restaurants,
    required this.restaurant,
    required this.cart,
  }) : super(restaurants: restaurants);

  @override
  List<Object?> get props => [restaurants, restaurant, cart];
}

class OrderFailure extends OrderState {
  final String message;
  const OrderFailure({required List<Restaurant> restaurants, required this.message})
      : super(restaurants: restaurants);

  @override
  List<Object?> get props => [restaurants, message];
}

/// -------- BLOC ----------

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<LoadRestaurants>((event, emit) {
      emit(OrderInitial(restaurants: event.restaurants));
    });

    on<SelectRestaurant>((event, emit) {
      emit(OrderInProgress(
        restaurants: state.restaurants,
        restaurant: event.restaurant,
        cart: [],
      ));
    });

    on<AddItemToCart>((event, emit) {
      if (state is OrderInProgress) {
        final current = state as OrderInProgress;
        final updatedCart = List<FoodItem>.from(current.cart)..add(event.item);
        emit(OrderInProgress(
          restaurants: current.restaurants,
          restaurant: current.restaurant,
          cart: updatedCart,
        ));
      }
    });

    on<RemoveItemFromCart>((event, emit) {
      if (state is OrderInProgress) {
        final current = state as OrderInProgress;
        final updatedCart = List<FoodItem>.from(current.cart)..remove(event.item);
        emit(OrderInProgress(
          restaurants: current.restaurants,
          restaurant: current.restaurant,
          cart: updatedCart,
        ));
      }
    });

    on<PlaceOrder>((event, emit) {
      if (state is OrderInProgress) {
        final current = state as OrderInProgress;
        if (current.cart.isEmpty) {
          emit(OrderFailure(
            restaurants: current.restaurants,
            message: "Cart is empty. Add items to place order.",
          ));
        } else {
          emit(OrderSuccess(
            restaurants: current.restaurants,
            restaurant: current.restaurant!,
            cart: current.cart,
          ));
        }
      }
    });

    on<ResetOrder>((event, emit) {
      // Go back to initial, but keep restaurants
      emit(OrderInitial(restaurants: state.restaurants));
    });
  }
}

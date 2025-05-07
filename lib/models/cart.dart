import "./cart_item.dart";
import "./user.dart";

class Cart {
  final User user;
  List<CartItem> items;

  Cart({List<CartItem>? items, required this.user}) : items = items ?? [];
}
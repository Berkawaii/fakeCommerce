import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class Cart {
  final int id;
  final int userId;
  final String date;
  @JsonKey(name: 'products')
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.items,
  });

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price ?? 0) * item.quantity);

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartItem {
  final int productId;
  final int quantity;
  final double? price; // Used for local calculation, not from API
  final String? title; // Used for UI display, not from API
  final String? imageUrl; // Used for UI display, not from API

  CartItem({
    required this.productId,
    required this.quantity,
    this.price,
    this.title,
    this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

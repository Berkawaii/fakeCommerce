// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  date: json['date'] as String,
  items: (json['products'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date,
  'products': instance.items,
};

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  productId: (json['productId'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num?)?.toDouble(),
  title: json['title'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
  'price': instance.price,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
};

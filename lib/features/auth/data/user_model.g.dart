// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
  name: json['name'] == null
      ? null
      : UserName.fromJson(json['name'] as Map<String, dynamic>),
  phone: json['phone'] as String?,
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'password': ?instance.password,
  'name': instance.name,
  'phone': instance.phone,
  'address': instance.address,
};

UserName _$UserNameFromJson(Map<String, dynamic> json) => UserName(
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
);

Map<String, dynamic> _$UserNameToJson(UserName instance) => <String, dynamic>{
  'firstname': instance.firstname,
  'lastname': instance.lastname,
};

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  city: json['city'] as String,
  street: json['street'] as String,
  number: (json['number'] as num).toInt(),
  zipcode: json['zipcode'] as String,
  geolocation: json['geolocation'] == null
      ? null
      : GeoLocation.fromJson(json['geolocation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'city': instance.city,
  'street': instance.street,
  'number': instance.number,
  'zipcode': instance.zipcode,
  'geolocation': instance.geolocation,
};

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) =>
    GeoLocation(lat: json['lat'] as String, long: json['long'] as String);

Map<String, dynamic> _$GeoLocationToJson(GeoLocation instance) =>
    <String, dynamic>{'lat': instance.lat, 'long': instance.long};

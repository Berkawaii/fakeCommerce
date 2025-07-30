import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String email;
  @JsonKey(includeIfNull: false)
  final String? password;
  @JsonKey(name: 'name')
  final UserName? name;
  final String? phone;
  final Address? address;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    this.name,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'username': username,
      'email': email,
    };

    if (password != null) {
      data['password'] = password;
    }

    if (name != null) {
      data['name'] = {'firstname': name!.firstname, 'lastname': name!.lastname};
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (address != null) {
      data['address'] = address!.toJson();
    }

    return data;
  }
}

@JsonSerializable()
class UserName {
  final String firstname;
  final String lastname;

  UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);
  Map<String, dynamic> toJson() => _$UserNameToJson(this);
}

@JsonSerializable()
class Address {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocation? geolocation;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    this.geolocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class GeoLocation {
  final String lat;
  final String long;

  GeoLocation({required this.lat, required this.long});

  factory GeoLocation.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeoLocationToJson(this);
}

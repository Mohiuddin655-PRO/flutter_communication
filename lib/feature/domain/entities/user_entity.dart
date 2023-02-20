import 'dart:developer';

import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

class UserEntity extends Entity {
  final String email;
  final String name;
  final String password;
  final String phone;
  final String photo;
  final String provider;
  final String designation;
  final String city;
  final String workplace;
  final List<String> chatRooms;

  const UserEntity({
    super.id,
    this.email = "",
    this.name = "",
    this.password = "",
    this.phone = "",
    this.photo = "",
    this.provider = "",
    this.designation = "",
    this.city = "",
    this.workplace = "",
    this.chatRooms = const [],
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    String? phone,
    String? photo,
    String? provider,
    String? designation,
    String? city,
    String? workplace,
    List<String>? chatRooms,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      provider: provider ?? this.provider,
      designation: designation ?? this.designation,
      city: city ?? this.city,
      workplace: workplace ?? this.workplace,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }

  factory UserEntity.from(dynamic data) {
    dynamic id, email, name, password, phone, photo, provider;
    dynamic designation, city, workplace;
    dynamic chatRooms;
    List<String> rooms = [];
    if (data is Map) {
      try {
        id = data['id'];
        email = data['email'];
        name = data['name'];
        password = data['password'];
        phone = data['phone'];
        photo = data['photo'];
        provider = data['provider'];
        designation = data['designation'];
        city = data['city'];
        workplace = data['workplace'];
        chatRooms = data['chat_rooms'];
        rooms = chatRooms is List
            ? chatRooms.map((e) => e.toString()).toList()
            : <String>[];
        return UserEntity(
          id: id is String ? id : "",
          email: email is String ? email : "",
          name: name is String ? name : "",
          password: password is String ? password : "",
          phone: phone is String ? phone : "",
          photo: photo is String ? photo : "",
          provider: provider is String ? provider : "",
          designation: designation is String ? designation : "",
          city: city is String ? city : "",
          workplace: workplace is String ? workplace : "",
          chatRooms: rooms,
        );
      } catch (e) {
        log(e.toString());
      }
    }
    return const UserEntity();
  }

  bool get isCurrentUid => id == AuthHelper.uid;

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "photo": photo,
      "provider": provider,
      "designation": designation,
      "home_district": city,
      "workplace": workplace,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        password,
        phone,
        photo,
        provider,
        designation,
        city,
        workplace,
      ];
}

enum AuthProvider {
  email,
  phone,
  facebook,
  google,
  twitter,
  apple,
}

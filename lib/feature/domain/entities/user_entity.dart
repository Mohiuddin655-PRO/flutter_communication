import 'dart:developer';

import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

class UserEntity extends Entity<UserEntity> {
  final String? email;
  final String? name;
  final String? password;
  final String? phone;
  final String? photo;
  final String? provider;
  final String? designation;
  final String? homeDistrict;
  final String? workplace;

  const UserEntity({
    super.id,
    this.email,
    this.name,
    this.password,
    this.phone,
    this.photo,
    this.provider,
    this.designation,
    this.homeDistrict,
    this.workplace,
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
    String? homeDistrict,
    String? workplace,
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
      homeDistrict: homeDistrict ?? this.homeDistrict,
      workplace: workplace ?? this.workplace,
    );
  }

  factory UserEntity.from(dynamic data) {
    dynamic id, email, name, password, phone, photo, provider;
    dynamic designation, homeDistrict, workplace;
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
        homeDistrict = data['home_district'];
        workplace = data['workplace'];
        return UserEntity(
          id: id,
          email: email,
          name: name,
          password: password,
          phone: phone,
          photo: photo,
          provider: provider,
          designation: designation,
          homeDistrict: homeDistrict,
          workplace: workplace,
        );
      } catch (e) {
        log(e.toString());
      }
    }
    return const UserEntity();
  }

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
      "home_district": homeDistrict,
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
        homeDistrict,
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

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

class UserEntity extends Equatable {
  final String? email;
  final String? name;
  final String? password;
  final String? phone;
  final String? photo;
  final String? uid;
  final String? provider;
  final String? designation;
  final String? hallName;
  final String? homeDistrict;
  final String? workplace;

  const UserEntity({
    this.email,
    this.name,
    this.password,
    this.phone,
    this.photo,
    this.uid,
    this.provider,
    this.designation,
    this.hallName,
    this.homeDistrict,
    this.workplace,
  });

  UserEntity copyWith({
    String? email,
    String? name,
    String? password,
    String? phone,
    String? photo,
    String? uid,
    String? provider,
    String? designation,
    String? hallName,
    String? homeDistrict,
    String? workplace,
  }) {
    return UserEntity(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      uid: uid ?? this.uid,
      provider: provider ?? this.provider,
      designation: designation ?? this.designation,
      hallName: hallName ?? this.hallName,
      homeDistrict: homeDistrict ?? this.homeDistrict,
      workplace: workplace ?? this.workplace,
    );
  }

  factory UserEntity.from(dynamic data) {
    dynamic email, name, password, phone, photo, uid, provider;
    dynamic designation, hallName, homeDistrict, workplace;
    try {
      if (data is DataSnapshot) {
        email = data.child('email');
        name = data.child('name');
        password = data.child('password');
        phone = data.child('phone');
        photo = data.child('photo');
        uid = data.child('uid');
        provider = data.child('provider');
        designation = data.child('designation');
        hallName = data.child('hall_name');
        homeDistrict = data.child('home_district');
        workplace = data.child('workplace');
      } else {
        email = data['email'];
        name = data['name'];
        password = data['password'];
        phone = data['phone'];
        photo = data['photo'];
        uid = data['uid'];
        provider = data['provider'];
        designation = data['designation'];
        hallName = data['hall_name'];
        homeDistrict = data['home_district'];
        workplace = data['workplace'];
      }
    } catch (e) {
      log(e.toString());
    }
    return UserEntity(
      email: email,
      name: name,
      password: password,
      phone: phone,
      photo: photo,
      uid: uid,
      provider: provider,
      designation: designation,
      hallName: hallName,
      homeDistrict: homeDistrict,
      workplace: workplace,
    );
  }

  Map<String, dynamic> get map {
    return {
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "photo": photo,
      "uid": uid,
      "provider": provider,
      "designation": designation,
      "hall_name": hallName,
      "home_district": homeDistrict,
      "workplace": workplace,
    };
  }

  @override
  String toString() {
    return "email : $email, name : $name, password : $password, phone : $phone, photo : $photo, uid : $uid, provider : $provider, designation : $designation, hallName : $hallName, homeDistrict : $homeDistrict, workplace : $workplace";
  }

  @override
  List<Object?> get props => [
        email,
        name,
        password,
        phone,
        photo,
        uid,
        provider,
        designation,
        hallName,
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

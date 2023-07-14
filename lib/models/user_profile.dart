import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? businessName;
  String? businessAddress;
  bool? isActive;
  Timestamp? lastLoggedIn;
  Timestamp? lastUpdated;
  Timestamp? createdAt;
  double? totalUnit;
  double? lastRestocked;
  UserProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.businessName,
    this.businessAddress,
    this.isActive,
    this.lastLoggedIn,
    this.lastUpdated,
    this.createdAt,
    this.totalUnit,
    this.lastRestocked,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? businessName,
    String? businessAddress,
    bool? isActive,
    Timestamp? lastLoggedIn,
    Timestamp? lastUpdated,
    Timestamp? createdAt,
    double? totalUnit,
    double? lastRestocked,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      isActive: isActive ?? this.isActive,
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      totalUnit: totalUnit ?? this.totalUnit,
      lastRestocked: lastRestocked ?? this.lastRestocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'isActive': isActive,
      'lastLoggedIn': lastLoggedIn,
      'lastUpdated': lastUpdated,
      'createdAt': createdAt,
      'totalUnit': totalUnit,
      'lastRestocked': lastRestocked,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      image: map['image'],
      businessName: map['businessName'],
      businessAddress: map['businessAddress'],
      isActive: map['isActive'],
      lastLoggedIn: map['lastLoggedIn'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['lastLoggedIn'])
          : null,
      lastUpdated: map['lastUpdated'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['lastUpdated'])
          : null,
      createdAt: map['createdAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      totalUnit: map['totalUnit']?.toDouble(),
      lastRestocked: map['lastRestocked']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, phone: $phone, image: $image, businessName: $businessName, businessAddress: $businessAddress, isActive: $isActive, lastLoggedIn: $lastLoggedIn, lastUpdated: $lastUpdated, createdAt: $createdAt, totalUnit: $totalUnit, lastRestocked: $lastRestocked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.image == image &&
        other.businessName == businessName &&
        other.businessAddress == businessAddress &&
        other.isActive == isActive &&
        other.lastLoggedIn == lastLoggedIn &&
        other.lastUpdated == lastUpdated &&
        other.createdAt == createdAt &&
        other.totalUnit == totalUnit &&
        other.lastRestocked == lastRestocked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        image.hashCode ^
        businessName.hashCode ^
        businessAddress.hashCode ^
        isActive.hashCode ^
        lastLoggedIn.hashCode ^
        lastUpdated.hashCode ^
        createdAt.hashCode ^
        totalUnit.hashCode ^
        lastRestocked.hashCode;
  }
}

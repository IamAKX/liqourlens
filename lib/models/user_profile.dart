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
  String? lastRestockedItemName;
  String? reportSheet;
  String? nameColumn;
  String? qtyColumn;
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
    this.lastRestockedItemName,
    this.reportSheet,
    this.nameColumn,
    this.qtyColumn,
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
    String? lastRestockedItemName,
    String? reportSheet,
    String? nameColumn,
    String? qtyColumn,
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
      lastRestockedItemName:
          lastRestockedItemName ?? this.lastRestockedItemName,
      reportSheet: reportSheet ?? this.reportSheet,
      nameColumn: nameColumn ?? this.nameColumn,
      qtyColumn: qtyColumn ?? this.qtyColumn,
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
      'lastRestockedItemName': lastRestockedItemName,
      'reportSheet': reportSheet,
      'nameColumn': nameColumn,
      'qtyColumn': qtyColumn,
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
      lastLoggedIn: map['lastLoggedIn'],
      lastUpdated: map['lastUpdated'],
      createdAt: map['createdAt'],
      totalUnit: map['totalUnit']?.toDouble(),
      lastRestocked: map['lastRestocked']?.toDouble(),
      lastRestockedItemName: map['lastRestockedItemName'],
      reportSheet: map['reportSheet'],
      nameColumn: map['nameColumn'],
      qtyColumn: map['qtyColumn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, phone: $phone, image: $image, businessName: $businessName, businessAddress: $businessAddress, isActive: $isActive, lastLoggedIn: $lastLoggedIn, lastUpdated: $lastUpdated, createdAt: $createdAt, totalUnit: $totalUnit, lastRestocked: $lastRestocked, lastRestockedItemName: $lastRestockedItemName, reportSheet: $reportSheet, nameColumn: $nameColumn, qtyColumn: $qtyColumn)';
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
        other.lastRestocked == lastRestocked &&
        other.lastRestockedItemName == lastRestockedItemName &&
        other.reportSheet == reportSheet &&
        other.nameColumn == nameColumn &&
        other.qtyColumn == qtyColumn;
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
        lastRestocked.hashCode ^
        lastRestockedItemName.hashCode ^
        reportSheet.hashCode ^
        nameColumn.hashCode ^
        qtyColumn.hashCode;
  }
}

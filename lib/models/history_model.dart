import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String? id;
  String? name;
  String? upc;
  String? updateType;
  Timestamp? lastUpdateTime;
  double? quantity;
  double? updateValue;
  HistoryModel({
    this.id,
    this.name,
    this.upc,
    this.updateType,
    this.lastUpdateTime,
    this.quantity,
    this.updateValue,
  });

  HistoryModel copyWith({
    String? id,
    String? name,
    String? upc,
    String? updateType,
    Timestamp? lastUpdateTime,
    double? quantity,
    double? updateValue,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      upc: upc ?? this.upc,
      updateType: updateType ?? this.updateType,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      quantity: quantity ?? this.quantity,
      updateValue: updateValue ?? this.updateValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'upc': upc,
      'updateType': updateType,
      'lastUpdateTime': lastUpdateTime,
      'quantity': quantity,
      'updateValue': updateValue,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      name: map['name'],
      upc: map['upc'],
      updateType: map['updateType'],
      lastUpdateTime: map['lastUpdateTime'],
      quantity: map['quantity']?.toDouble(),
      updateValue: map['updateValue']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryModel(id: $id, name: $name, upc: $upc, updateType: $updateType, lastUpdateTime: $lastUpdateTime, quantity: $quantity, updateValue: $updateValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryModel &&
        other.id == id &&
        other.name == name &&
        other.upc == upc &&
        other.updateType == updateType &&
        other.lastUpdateTime == lastUpdateTime &&
        other.quantity == quantity &&
        other.updateValue == updateValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        upc.hashCode ^
        updateType.hashCode ^
        lastUpdateTime.hashCode ^
        quantity.hashCode ^
        updateValue.hashCode;
  }
}

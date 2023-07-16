import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:alcohol_inventory/models/upc_item_model.dart';

class InventoryModel {
  UpcItemModel? item;
  String? updateType;
  Timestamp? lastUpdateTime;
  double? quanty;
  double? updateValue;
  InventoryModel({
    this.item,
    this.updateType,
    this.lastUpdateTime,
    this.quanty,
    this.updateValue,
  });

  InventoryModel copyWith({
    UpcItemModel? item,
    String? updateType,
    Timestamp? lastUpdateTime,
    double? quanty,
    double? updateValue,
  }) {
    return InventoryModel(
      item: item ?? this.item,
      updateType: updateType ?? this.updateType,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      quanty: quanty ?? this.quanty,
      updateValue: updateValue ?? this.updateValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item?.toMap(),
      'updateType': updateType,
      'lastUpdateTime': lastUpdateTime,
      'quanty': quanty,
      'updateValue': updateValue,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      item: map['item'] != null ? UpcItemModel.fromMap(map['item']) : null,
      updateType: map['updateType'],
      lastUpdateTime: map['lastUpdateTime'],
      quanty: map['quanty']?.toDouble(),
      updateValue: map['updateValue']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryModel.fromJson(String source) =>
      InventoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InventoryModel(item: $item, updateType: $updateType, lastUpdateTime: $lastUpdateTime, quanty: $quanty, updateValue: $updateValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InventoryModel &&
        other.item == item &&
        other.updateType == updateType &&
        other.lastUpdateTime == lastUpdateTime &&
        other.quanty == quanty &&
        other.updateValue == updateValue;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        updateType.hashCode ^
        lastUpdateTime.hashCode ^
        quanty.hashCode ^
        updateValue.hashCode;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:alcohol_inventory/models/upc_item_model.dart';

class UpcResponseModel {
  String? code;
  int? total;
  List<UpcItemModel>? items;
  UpcResponseModel({
    this.code,
    this.total,
    this.items,
  });

  UpcResponseModel copyWith({
    String? code,
    int? total,
    List<UpcItemModel>? items,
  }) {
    return UpcResponseModel(
      code: code ?? this.code,
      total: total ?? this.total,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'total': total,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory UpcResponseModel.fromMap(Map<String, dynamic> map) {
    return UpcResponseModel(
      code: map['code'],
      total: map['total']?.toInt(),
      items: map['items'] != null
          ? List<UpcItemModel>.from(
              map['items']?.map((x) => UpcItemModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpcResponseModel.fromJson(String source) =>
      UpcResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UpcResponseModel(code: $code, total: $total, items: $items)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpcResponseModel &&
        other.code == code &&
        other.total == total &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => code.hashCode ^ total.hashCode ^ items.hashCode;
}

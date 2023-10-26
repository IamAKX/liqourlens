import 'dart:convert';

import 'package:flutter/foundation.dart';

class InventoryItemViewModel {
  List<String>? items;
  InventoryItemViewModel({
    this.items,
  });

  InventoryItemViewModel copyWith({
    List<String>? items,
  }) {
    return InventoryItemViewModel(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory InventoryItemViewModel.fromMap(Map<String, dynamic> map) {
    return InventoryItemViewModel(
      items: List<String>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryItemViewModel.fromJson(String source) => InventoryItemViewModel.fromMap(json.decode(source));

  @override
  String toString() => 'InventoryItemViewModel(items: $items)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is InventoryItemViewModel &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

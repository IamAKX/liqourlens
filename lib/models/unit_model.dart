import 'dart:convert';

class UnitModel {
  String? code;
  String? name;
  String? date;
  String? quantity;
  String? type;
  UnitModel({
    this.code,
    this.name,
    this.date,
    this.quantity,
    this.type,
  });

  UnitModel copyWith({
    String? code,
    String? name,
    String? date,
    String? quantity,
    String? type,
  }) {
    return UnitModel(
      code: code ?? this.code,
      name: name ?? this.name,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'date': date,
      'quantity': quantity,
      'type': type,
    };
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      code: map['code'],
      name: map['name'],
      date: map['date'],
      quantity: map['quantity'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitModel.fromJson(String source) =>
      UnitModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnitModel(code: $code, name: $name, date: $date, quantity: $quantity, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnitModel &&
        other.code == code &&
        other.name == name &&
        other.date == date &&
        other.quantity == quantity &&
        other.type == type;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        name.hashCode ^
        date.hashCode ^
        quantity.hashCode ^
        type.hashCode;
  }
}

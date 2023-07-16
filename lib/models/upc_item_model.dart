import 'dart:convert';

import 'package:flutter/foundation.dart';

class UpcItemModel {
  String? ean;
  String? title;
  String? description;
  String? upc;
  String? brand;
  String? model;
  String? color;
  String? size;
  String? dimension;
  String? weight;
  String? category;
  String? currency;
  double? lowestRecordedPrice;
  double? highestRecordedPrice;
  List<String>? images;
  String? elid;
  UpcItemModel({
    this.ean,
    this.title,
    this.description,
    this.upc,
    this.brand,
    this.model,
    this.color,
    this.size,
    this.dimension,
    this.weight,
    this.category,
    this.currency,
    this.lowestRecordedPrice,
    this.highestRecordedPrice,
    this.images,
    this.elid,
  });

  UpcItemModel copyWith({
    String? ean,
    String? title,
    String? description,
    String? upc,
    String? brand,
    String? model,
    String? color,
    String? size,
    String? dimension,
    String? weight,
    String? category,
    String? currency,
    double? lowestRecordedPrice,
    double? highestRecordedPrice,
    List<String>? images,
    String? elid,
  }) {
    return UpcItemModel(
      ean: ean ?? this.ean,
      title: title ?? this.title,
      description: description ?? this.description,
      upc: upc ?? this.upc,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      color: color ?? this.color,
      size: size ?? this.size,
      dimension: dimension ?? this.dimension,
      weight: weight ?? this.weight,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      lowestRecordedPrice: lowestRecordedPrice ?? this.lowestRecordedPrice,
      highestRecordedPrice: highestRecordedPrice ?? this.highestRecordedPrice,
      images: images ?? this.images,
      elid: elid ?? this.elid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ean': ean,
      'title': title,
      'description': description,
      'upc': upc,
      'brand': brand,
      'model': model,
      'color': color,
      'size': size,
      'dimension': dimension,
      'weight': weight,
      'category': category,
      'currency': currency,
      'lowestRecordedPrice': lowestRecordedPrice,
      'highestRecordedPrice': highestRecordedPrice,
      'images': images,
      'elid': elid,
    };
  }

  factory UpcItemModel.fromMap(Map<String, dynamic> map) {
    return UpcItemModel(
      ean: map['ean'],
      title: map['title'],
      description: map['description'],
      upc: map['upc'],
      brand: map['brand'],
      model: map['model'],
      color: map['color'],
      size: map['size'],
      dimension: map['dimension'],
      weight: map['weight'],
      category: map['category'],
      currency: map['currency'],
      lowestRecordedPrice: map['lowestRecordedPrice']?.toDouble(),
      highestRecordedPrice: map['highestRecordedPrice']?.toDouble(),
      images: List<String>.from(map['images']),
      elid: map['elid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpcItemModel.fromJson(String source) =>
      UpcItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpcItemModel(ean: $ean, title: $title, description: $description, upc: $upc, brand: $brand, model: $model, color: $color, size: $size, dimension: $dimension, weight: $weight, category: $category, currency: $currency, lowestRecordedPrice: $lowestRecordedPrice, highestRecordedPrice: $highestRecordedPrice, images: $images, elid: $elid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpcItemModel &&
        other.ean == ean &&
        other.title == title &&
        other.description == description &&
        other.upc == upc &&
        other.brand == brand &&
        other.model == model &&
        other.color == color &&
        other.size == size &&
        other.dimension == dimension &&
        other.weight == weight &&
        other.category == category &&
        other.currency == currency &&
        other.lowestRecordedPrice == lowestRecordedPrice &&
        other.highestRecordedPrice == highestRecordedPrice &&
        listEquals(other.images, images) &&
        other.elid == elid;
  }

  @override
  int get hashCode {
    return ean.hashCode ^
        title.hashCode ^
        description.hashCode ^
        upc.hashCode ^
        brand.hashCode ^
        model.hashCode ^
        color.hashCode ^
        size.hashCode ^
        dimension.hashCode ^
        weight.hashCode ^
        category.hashCode ^
        currency.hashCode ^
        lowestRecordedPrice.hashCode ^
        highestRecordedPrice.hashCode ^
        images.hashCode ^
        elid.hashCode;
  }
}

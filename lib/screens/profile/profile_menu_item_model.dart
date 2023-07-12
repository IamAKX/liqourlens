import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileMenuItemModel {
  String name;
  String path;
  IconData icon;
  ProfileMenuItemModel({
    required this.name,
    required this.path,
    required this.icon,
  });

  ProfileMenuItemModel copyWith({
    String? name,
    String? path,
    IconData? icon,
  }) {
    return ProfileMenuItemModel(
      name: name ?? this.name,
      path: path ?? this.path,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'icon': icon.codePoint,
    };
  }

  factory ProfileMenuItemModel.fromMap(Map<String, dynamic> map) {
    return ProfileMenuItemModel(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileMenuItemModel.fromJson(String source) =>
      ProfileMenuItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProfileMenuItemModel(name: $name, path: $path, icon: $icon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileMenuItemModel &&
        other.name == name &&
        other.path == path &&
        other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ path.hashCode ^ icon.hashCode;
}

import 'package:flutter/material.dart';

const String tableLabels = 'labels';

class LabelFields {
  static final List<String> values = [
    id,
    label,
    dateAdded,
    dateModified,
    color,
  ];

  static const String id = '_id';
  static const String label = 'label';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
  static const String color = 'color';
}

class Label {
  /// The id for a label.
  final int? id;

  /// The label name.
  final String label;

  /// The date this label was added to the database.
  final DateTime? dateAdded;

  /// The date this label was last modified.
  final DateTime? dateModified;

  /// The color to associate with this label.
  final Color? color;

  Label({
    this.id,
    required this.label,
    this.color,
    this.dateAdded,
    this.dateModified,
  });

  Label copy({
    final int? id,
    final String? label,
    final DateTime? dateAdded,
    final DateTime? dateModified,
    final Color? color,
  }) =>
      Label(
        id: id ?? this.id,
        label: label ?? this.label,
        color: color ?? this.color,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
      );

  Map<String, Object?> toJson() => {
        LabelFields.id: id,
        LabelFields.label: label,
        LabelFields.dateAdded: dateAdded?.toIso8601String(),
        LabelFields.dateModified: dateModified?.toIso8601String(),
        LabelFields.color: color?.value,
      };

  static Label fromJson(Map<String, Object?> json) => Label(
        id: json[LabelFields.id] as int?,
        label: json[LabelFields.label] as String,
        color: (json[LabelFields.color] as int?) != null
            ? Color(json[LabelFields.color] as int)
            : null,
        dateAdded: DateTime.parse(json[LabelFields.dateAdded] as String),
        dateModified: DateTime.parse(json[LabelFields.dateModified] as String),
      );

  @override
  bool operator ==(Object other) => other is Label && other.id == id;

  @override
  int get hashCode => id ?? 0;
}

import 'package:flutter/material.dart';

const String tableLabels = 'labels';

class LabelFields {
  static final List<String> values = [
    id,
    label,
    dateAdded,
    color,
  ];

  static const String id = '_id';
  static const String label = 'label';
  static const String dateAdded = 'dateAdded';
  static const String color = 'color';
}

class Label {
  /// The id for a label.
  final int? id;

  /// The label name.
  final String label;

  /// The date this label was generated.
  final DateTime dateAdded = DateTime.now();

  /// The color to associate with this label.
  final Color? color;

  Label({
    this.id,
    required this.label,
    this.color,
  });

  Label copy({
    final int? id,
    final String? label,
    final DateTime? dateAdded,
    final Color? color,
  }) =>
      Label(
        id: id ?? id,
        label: label ?? this.label,
        color: color ?? this.color,
      );

  Map<String, Object?> toJson() => {
        LabelFields.id: id,
        LabelFields.label: label,
        LabelFields.dateAdded: dateAdded.toIso8601String(),
        LabelFields.color: color?.value,
      };

  static Label fromJson(Map<String, Object?> json) => Label(
        id: json[LabelFields.id] as int?,
        label: json[LabelFields.label] as String,
        color: (json[LabelFields.color] as int?) != null
            ? Color(json[LabelFields.color] as int)
            : null,
      );
}

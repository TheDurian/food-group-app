import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  final int total;
  final int activated;

  const StarWidget({
    super.key,
    this.total = 5,
    this.activated = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        var filled = index < activated;
        return Icon(filled ? Icons.star : Icons.star_border);
      }).toList(),
    );
  }
}

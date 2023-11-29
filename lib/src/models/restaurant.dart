// TODO V2 delivered/delivery details

import 'package:food_group_app/src/models/person.dart';

class Restaurant {
  final String id;
  final String name;
  final List<String>? labels;
  final bool? isChain;
  final String? address;
  final DateTime? dateVisited;
  final List<Person>? peopleInvolved;

  Restaurant({
    required this.id,
    required this.name,
    this.labels,
    this.isChain,
    this.address,
    this.dateVisited,
    this.peopleInvolved,
  });
}

import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/services/google/place_service.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';
import 'package:food_group_app/src/utils/extensions.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 150,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: GooglePlaceService.getPhotoFromReference(
                  restaurant.photoReference,
                  300,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Visited: ${DateTimeHelper.toDate(restaurant.dateVisited)}',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 20),
                              Text(
                                '${restaurant.persons?.length}',
                                style: context.textTheme.titleSmall?.copyWith(
                                  color:
                                      context.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                              ),
                              const Icon(Icons.star, size: 20),
                              Text(
                                restaurant
                                    .getAverageRating()
                                    .toStringAsFixed(1),
                                style: context.textTheme.titleSmall?.copyWith(
                                  color:
                                      context.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

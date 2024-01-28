import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/widgets/multiple_stars.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final List<Rating> ratings;
  final VoidCallback onClick;

  const PersonCard({
    super.key,
    required this.person,
    required this.ratings,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: 75,
          child: Card(
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    person.firstName.toUpperCase().characters.first,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                title: Text(
                  person.fullName(),
                ),
                trailing: ratings.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${ratings.length}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          IconTheme(
                            data: IconThemeData(
                              size: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            child: const StarWidget(),
                          ),
                        ],
                      )
                    : null,
                onTap: onClick,
              ),
            ),
          ),
        ),
      );
}

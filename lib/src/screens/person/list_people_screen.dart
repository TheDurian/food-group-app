import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/sorts/person_sort.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/person_db.dart';
import 'package:food_group_app/src/services/database/rating_db.dart';
import 'package:food_group_app/src/utils/extensions.dart';
import 'package:food_group_app/src/utils/shared_prefs.dart';
import 'package:food_group_app/src/widgets/cards/person_card.dart';

class ListPeopleScreen extends StatefulWidget {
  const ListPeopleScreen({super.key});

  @override
  State<ListPeopleScreen> createState() => _ListPeopleScreenState();
}

class _ListPeopleScreenState extends State<ListPeopleScreen> {
  // A list of filtered people.
  late List<Map<Person, List<Rating>>> filteredPeople;

  /// A flag for whether a database call is ongoing or not.
  bool isLoading = false;

  /// The selected filter.
  PersonSort selectedFilter = SharedPrefs().personSort;

  @override
  void initState() {
    super.initState();
    filteredPeople = [];
    refreshPeople();
  }

  /// Refresh the active restaurants.
  Future<void> refreshPeople() async {
    setState(() => isLoading = true);
    List<Person> dbPeople = await PersonDatabase.readAllPersons();
    List<Map<Person, List<Rating>>> list = [];
    for (Person person in dbPeople) {
      List<Rating> ratings = await RatingDatabase.readRatingsForPerson(
        person.id!,
      );

      list.add({person: ratings});
    }
    setState(() => filteredPeople = list);
    sortPeople();
    setState(() => isLoading = false);
  }

  /// A function to sort the currently retrieved people.
  ///
  /// This is to be used if no database call to re-fetch
  /// all people is needed.
  void sortPeople() {
    setState(() => filteredPeople.sort(selectedFilter.sort));
  }

  void showSortModal() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        showDragHandle: true,
        builder: (BuildContext context) => Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Sort",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: context.colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ...PersonSort.values.map(
                    (filter) => RadioListTile<PersonSort>(
                      title: Text(filter.name),
                      value: filter,
                      groupValue: selectedFilter,
                      onChanged: (PersonSort? value) {
                        if (value != null) {
                          setState(() {
                            selectedFilter = value;
                            SharedPrefs().personSort = value;
                          });
                          sortPeople();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sorted by ${selectedFilter.name}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: const Text('People'),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: showSortModal,
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
            isLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                          height: 100, child: CircularProgressIndicator()),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: filteredPeople.length,
                      (context, index) => PersonCard(
                        person: filteredPeople[index].entries.first.key,
                        ratings: filteredPeople[index].entries.first.value,
                        onClick: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.editPerson,
                            arguments: filteredPeople[index].entries.first.key,
                          );
                          refreshPeople();
                        },
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.editPerson,
            );
            refreshPeople();
          },
          label: const Text(
            'New Person',
          ),
          icon: const Icon(
            Icons.add,
          ),
        ),
      );

  /// Builds the tiles for all saved people in the database.
  Widget buildTileList() => ListView.builder(
        itemCount: filteredPeople.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: PersonCard(
            person: filteredPeople[index].entries.first.key,
            ratings: filteredPeople[index].entries.first.value,
            onClick: () async {
              await Navigator.pushNamed(
                context,
                AppRoutes.editPerson,
                arguments: filteredPeople[index].entries.first.key,
              );
              refreshPeople();
            },
          ),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      );
}

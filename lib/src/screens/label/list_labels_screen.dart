import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/label_db.dart';

class ListLabelsScreen extends StatefulWidget {
  const ListLabelsScreen({super.key});

  @override
  State<ListLabelsScreen> createState() => _ListLabelsScreenState();
}

class _ListLabelsScreenState extends State<ListLabelsScreen> {
  late List<Label> filteredLabels;

  /// A flag for whether a database call is ongoing or not.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredLabels = [];
    refreshLabels();
  }

  /// Refresh the active restaurants.
  Future<void> refreshLabels() async {
    setState(() => isLoading = true);
    List<Label> dbLabels = await LabelDatabase.readAllLabels();
    setState(() => filteredLabels = dbLabels);
    // sortPeople();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('Labels'),
              pinned: true,
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
                      childCount: filteredLabels.length,
                      (context, index) => Card(
                        child: ListTile(
                          title: Text(filteredLabels[index].label),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.editLabel,
                              arguments: filteredLabels[index].label,
                            );
                            refreshLabels();
                          },
                        ),
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
              AppRoutes.editLabel,
            );
            refreshLabels();
          },
          label: const Text(
            'New Label',
          ),
          icon: const Icon(
            Icons.add,
          ),
        ),
      );
}

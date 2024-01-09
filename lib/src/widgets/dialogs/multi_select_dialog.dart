import 'package:flutter/material.dart';

class MultiSelectDialog<T> extends StatefulWidget {
  /// A list of pre-existing selected items.
  final List<T> selectedItems;

  // The text to display for the button representing cancelation.
  final String cancelButtonText;

  /// The text to display for the button representing confirmation.
  final String confirmButtonText;

  /// The text to display along the top of the dialog.
  final String titleText;

  /// A function to handle clicking on the add icon
  ///
  /// The function should navigate or otherwise add
  /// another item of T
  final Future<void> Function() onAddClick;

  /// A function to handle creating the text to display for each checkbox.
  ///
  /// This function should take an item of type T and convert
  /// it to a String.
  final String Function(T) buildSelectedItemText;

  /// A function to be called to regenerate all existing items of type T.
  final Future<List<T>> Function() refreshAllItems;

  const MultiSelectDialog({
    super.key,
    required this.selectedItems,
    this.cancelButtonText = "Cancel",
    this.confirmButtonText = "Confirm",
    required this.titleText,
    required this.onAddClick, // TODO: May make this optional later
    required this.buildSelectedItemText,
    required this.refreshAllItems,
    // TODO: Maybe add a readOnly parameter which only shows items selected
  });

  @override
  State<MultiSelectDialog<T>> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  /// A map of items and whether they have been checked.
  late Map<T, bool> itemsChecked;

  /// A list of all current items.
  late List<T> allItems = [];

  /// A flag to determine when to display a loading indicator.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshAllItems();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: buildTitle(),
        content: buildContent(),
        actions: buildActionButtons(),
      );

  /// Function to regenerate all items on screen.
  Future<void> refreshAllItems() async {
    setState(() => isLoading = true);
    allItems = await widget.refreshAllItems();
    itemsChecked = {
      for (var e in allItems) e: widget.selectedItems.contains(e)
    };
    setState(() => isLoading = false);
  }

  /// Builds the title section of the alert dialog.
  Widget buildTitle() => Row(
        children: [
          Expanded(child: Text(widget.titleText)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await widget.onAddClick();
              refreshAllItems();
            },
          ),
        ],
      );

  /// Builds the action buttons on the alert dialog.
  ///
  /// The confirmation button will not appear unless
  /// at least 1 item is already in the list.
  List<Widget> buildActionButtons() => [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelButtonText),
        ),
        if (allItems.isNotEmpty)
          ElevatedButton(
            onPressed: () => Navigator.pop(
                context,
                itemsChecked.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList()),
            child: Text(widget.confirmButtonText),
          ),
      ];

  /// Builds the central content of the alert dialog.
  ///
  /// A loading indicator will display until the results
  /// of refreshAllItems returns the a value
  Widget buildContent() => isLoading
      ? const Center(child: CircularProgressIndicator())
      : SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: itemsChecked.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              T key = itemsChecked.keys.elementAt(index);
              return CheckboxListTile(
                title: Text(
                  widget.buildSelectedItemText(key),
                ),
                value: itemsChecked.values.elementAt(index),
                onChanged: (bool? value) {
                  setState(() => itemsChecked[key] = value ?? false);
                },
              );
            },
          ),
        );
}

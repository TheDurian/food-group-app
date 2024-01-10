import 'package:flutter/material.dart';
import 'package:food_group_app/src/widgets/dialogs/multi_select_dialog.dart';

class MultiSelectInput<T> extends StatefulWidget {
  /// String to display on the text input
  final String inputHintText;

  /// A list of currently selected items
  final List<T> selectedItems;

  /// Creates the text to display for each item and chip.
  final String Function(T) buildSelectedItemText;

  /// The text to display along the top of the dialog.
  final String titleText;

  /// A function that navigates to an edit page for an item.
  ///
  /// The function should return the newly edited item.
  final Future<T?> Function(T) onChipLongPress;

  /// A function to handle clicking on the add icon.
  final Future<void> Function() onAddClick;

  /// A function to call when selected items have changed.
  final ValueChanged<List<T>> onChangedSelectedItems;

  /// A function to be called to regenerate all existing items of type T.
  final Future<List<T>> Function() refreshAllItems;

  /// A function to be called to get the color for each chip.
  ///
  /// If no function is specified, no background color will be set.
  final Color? Function(T)? chipColor;

  /// A widget to display on the left side of each label.
  final Widget? labelAvatar;

  const MultiSelectInput({
    super.key,
    required this.inputHintText,
    required this.selectedItems,
    required this.onChangedSelectedItems,
    required this.buildSelectedItemText,
    required this.onChipLongPress,
    required this.titleText,
    required this.onAddClick,
    required this.refreshAllItems,
    this.labelAvatar,
    this.chipColor,
  });

  @override
  State<MultiSelectInput<T>> createState() => _MultiSelectInputState();
}

class _MultiSelectInputState<T> extends State<MultiSelectInput<T>> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          FormField(
            builder: (state) {
              return Column(
                children: [
                  buildSelectInput(),
                  const SizedBox(height: 8),
                  buildChips(),
                ],
              );
            },
          ),
        ],
      );

  /// Builds the input selection for a person list
  Widget buildSelectInput() => InkWell(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(widget.inputHintText),
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        onTap: () async {
          var selectedItems = await showDialog<List<T>>(
            context: context,
            builder: (BuildContext context) => MultiSelectDialog<T>(
              selectedItems: widget.selectedItems,
              titleText: widget.titleText,
              onAddClick: () async => await widget.onAddClick(),
              buildSelectedItemText: widget.buildSelectedItemText,
              refreshAllItems: widget.refreshAllItems,
            ),
          );
          if (selectedItems != null) {
            widget.onChangedSelectedItems(selectedItems);
          }
        },
      );

  /// Handles the long press functionality on a chip.
  void _handleLongPressOnChip(T chipData) async {
    var newItem = await widget.onChipLongPress(chipData);
    if (newItem != null) {
      // Probably really hacky solution
      var newList = List<T>.from(widget.selectedItems);
      newList[widget.selectedItems.indexWhere((e) => e == newItem)] = newItem;
      setState(() {
        widget.onChangedSelectedItems(newList);
      });
    }
  }

  /// Handles building the list of chips representing selected items.
  Widget buildChips() => Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 5,
          runSpacing: -2,
          alignment: WrapAlignment.start,
          children: widget.selectedItems
              .map((chipItem) => InkWell(
                    onLongPress: () => _handleLongPressOnChip(chipItem),
                    child: Chip(
                      label: Text(widget.buildSelectedItemText(chipItem)),
                      avatar: widget.labelAvatar,
                      deleteIcon: const Icon(Icons.close),
                      backgroundColor: widget.chipColor != null
                          ? widget.chipColor!(chipItem)
                          : null,
                      onDeleted: () =>
                          setState(() => widget.onChangedSelectedItems(
                                widget.selectedItems
                                    .where((e) => e != chipItem)
                                    .toList(),
                              )),
                    ),
                  ))
              .toList(),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:webrtc_flutter/features/create_room/view/create_room.dart';

class BaseDropdownMenu extends StatelessWidget {
  const BaseDropdownMenu({
    super.key,
    required this.width,
    required this.menuController,
    required this.menuItems,
    required this.onSelected,
  });

  final double width;
  final TextEditingController menuController;
  final List<MenuItem> menuItems;
  final ValueChanged<MenuItem?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownMenu<MenuItem>(
      controller: menuController,
      width: width,
      hintText: "Select Language",
      requestFocusOnTap: true,
      enableFilter: true,
      label: const Text('Select Language'),
      onSelected: (MenuItem? menu) {
        onSelected(menu);
      },
      dropdownMenuEntries:
          menuItems.map<DropdownMenuEntry<MenuItem>>((MenuItem menu) {
        return DropdownMenuEntry<MenuItem>(
          value: menu,
          label: menu.label,
        );
      }).toList(),
    );
  }
}
